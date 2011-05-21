Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1EUXGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 19:06:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50895 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1EUXGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 19:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=glSOIX7Df9W3esRsovtomG+1esCKJ7Xcte8zEmx8OGnPCiaVwLXQcWax+9GKkwY5YH
         0wuI0IHN7WJt/s/T5nBNKbB9wZ69So0SL0PyDpHQ7thhqs7QEub++ngtu4j2mWtzhJ4y
         +AbPaVKAqm53HBkCcVeBUT3B3ncWyPdiPxy98=
MIME-Version: 1.0
In-Reply-To: <1306017456.18455.1.camel@twins>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<1305907458.1465.23.camel@gandalf.stny.rr.com>
	<1305907896.1465.27.camel@gandalf.stny.rr.com>
	<201105210053.51314.toralf.foerster@gmx.de>
	<BANLkTinvtfpPr3GxKA49MN4y1q66HETorQ@mail.gmail.com>
	<1306017456.18455.1.camel@twins>
Date: Sun, 22 May 2011 01:06:46 +0200
Message-ID: <BANLkTinswk09M7bOup01EnrTNQycNbUMDw@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 12:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2011-05-21 at 12:12 +0200, richard -rw- weinberger wrote:
>> 2011/5/21 Toralf Förster <toralf.foerster@gmx.de>:
>> > Bisecting gave :
>> >
>> >
>> > git bisect badd123375425d7df4b6081a631fc1203fceafa59b2 is the first bad commit
>> > commit d123375425d7df4b6081a631fc1203fceafa59b2
>> > Author: Thomas Gleixner <tglx@linutronix.de>
>> > Date:   Wed Jan 26 21:32:01 2011 +0100
>> >
>> >    rwsem: Remove redundant asmregparm annotation
>> >
>> >    Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
>> >    compiling the kernel already with -mregparm=3. So the annotation of
>> >    the rwsem functions is redundant. Remove it.
>>
>> Ok, this bisect makes much more sense.
>>
>> Thomas, Peter, please revert d123375425d7df4b6081a631fc1203fceafa59b2.
>> We cannot compile UML with -mregparm=3 it would cause a lot of trouble.
>> It would break 32bit UML on 64bit and also on older 32bit systems like RHEL5.
>
> But why?

Why reverting?
d123375 effectively reverts commit d50efc6c (x86: fix UML and -regparm=3).

> Also, having to carry that asmregparm notation just for uml doesn't seem
> worth the trouble.
>

Frankly, I don't know why exactly UML breaks without having asmregparm.
I've seen this -regparm=3 thing today the very first time, I'll dig into it...

-- 
Thanks,
//richard
