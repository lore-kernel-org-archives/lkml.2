Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0K0Dqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 22:46:49 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33597 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab0K0Dqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 22:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W4Vqj9HU5SusuNl6Soa5cXyqEkMqxUiUIJWAcAueveyziQY/USnzMg3qq2I6vk3jbK
         UgEN0YvBGz9ycfUB5sHGUId8vqd3G1oaB9ca9E5vYf9A9RHyaHYumj19lOxJdBDcK4Kj
         YKTFeaR4U1sOw5JQodi/mgQbX3pLwwZ01NV4A=
MIME-Version: 1.0
In-Reply-To: <201011261622.29100.arnd@arndb.de>
References: <4CEE8A99.5020906@gmail.com>
	<20101125171613.GB18152@suse.de>
	<201011261622.29100.arnd@arndb.de>
Date: Sat, 27 Nov 2010 12:46:47 +0900
Message-ID: <AANLkTikddbZN2d+WWwJ_k7ZLpM5SS9H+2OLBZ1CgoZrB@mail.gmail.com>
Subject: Re: [RESEND][BUG][PATCH]-rc: USB: yurex: add .llseek fop to file_operations
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/27 Arnd Bergmann <arnd@arndb.de>:
> On Thursday 25 November 2010 18:16:13 Greg KH wrote:
>> On Fri, Nov 26, 2010 at 01:11:05AM +0900, Tomoki Sekiyama wrote:
>> > Hi Greg-KH,
>> > Sorry for resending this; To: was not enough.
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=23512
>> >
>> > Default llseek operation behavior was changed by the patch named
>> > "vfs: make no_llseek the default" after the yurex driver was merged,
>> > so the llseek to yurex is now ignored.
>> >
>> > This patch add llseek fop with default_llseek to yurex driver
>> > to catch up to the change.
>> >
>> > Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
>>
>> It's in my queue, sorry, been without power and water at home for a few
>> days, will catch up on this stuff next week...
>
> I was out most of the week, so I didn't get to look at it either.
> Is there an actual bug here caused by having no .llseek function?
>
> As far as I can tell, you don't really want to seek this file
> anyway, so the default behaviour of disallowing llseek would actually
> make more sense.

I need seek because the device notifies the update of the sensor's value
by fasync, then the user can rewind(seek to 0) and re-read the file.

Thanks,
--
Tomoki Sekiyama
