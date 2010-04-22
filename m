Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0DVXlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:41:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62120 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0DVXk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SI6fudYKtrQ47hh+Q0Uq1wasq9umULZ5bLB+FOu7jD3IEii/8xwl7HzLISKy2WTFxn
         cVBuLMobibuTXTkJROOrtaInBL3iTb+ujU5BKgjlxuRhKEZsvTmsskD8czLKsFl192Jy
         Xlc+Eph2O00naP/zhK2HDUbB5KLuGchqczUP0=
MIME-Version: 1.0
In-Reply-To: <20100304201548.GA1341@elf.ucw.cz>
References: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
	 <201003042026.30303.rjw@sisk.pl> <20100304201548.GA1341@elf.ucw.cz>
Date: Thu, 22 Apr 2010 16:40:58 -0700
Message-ID: <y2yf383264b1004221640rd1fca614zfa15d7e7984ab3ba@mail.gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
	userspace is frozen?
From: Matt Reimer <mattjreimer@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 1:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > My thought exactly.  This is the only approach that also solves the
>> > following race:
>> >
>> >     A driver is unloaded at the same time as a suspend starts.
>> >
>> >     The writeback thread gets frozen.
>> >
>> >     Then before the rmmod thread is frozen, it calls del_gendisk.
>> >
>> > Delaying things by means of a workqueue (or the equivalent) might also
>> > work, but it doesn't seem as safe.  For example, some important
>> > writebacks might end up getting delayed until too late.
>
> Delaying writebacks during sleep should be ok... That's why we do
> sync() after userspace is frozen -- nothing really important should be
> waiting for writeback after that point.

Has this been fixed, or has a consensus about how to fix this been
achieved? I'm hitting the same problem and have some time to work on a
fix.

Matt
