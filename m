Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1EQMd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:33:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53607 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1EQMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VEIctTGqvYG4AUXhEph9m4btsQOurPstEatI3u2TfSQ0/5HdRctN1CIjxlUK8V4s8Y
         GoNK9S5nscFPUdYKfJiNCiVDatYp++e1JaFifF07QlXFlgvd0gzBn4CwaFivVB5fiXLE
         cEkCn5W+gBI/ja74wKQw4P4GzKq3eCPpIN9Mo=
MIME-Version: 1.0
In-Reply-To: <20110516160114.GA25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-5-git-send-email-andi@firstfloor.org> <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com>
 <20110516160114.GA25898@one.firstfloor.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 17 May 2011 14:33:07 +0200
Message-ID: <BANLkTinscUoVpW1vuk4XQRTbcCoHb5oLXA@mail.gmail.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 6:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> ...and libc will start making many such calls in a row in order to retrieve
>> a dozen of such values.
>
> It doesn't because the user interface is sysconf(). So the user program
> just asks for it piece by piece.

Not if libc is caching known-to-be-constant-until-reboot data on the first call.

>> It's rather inefficient to return just one word.
>> Try to return more data per call.
>
> I considered that, but is there a concrete use case?
> I didn't want to code it up without concrete use case.

Look at recent history of having to add more syscalls
(such as signalfd/signalfd4) only because we didn't think through
how they will need to be extended.

It's likely you will need to return more than one long word
for some data, eventually. Therefore, better add struct now
than needing to add horrible hacks later in order to be able
to return an uint64_t value.

-- 
vda
