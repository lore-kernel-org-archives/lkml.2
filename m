Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab0DPEBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:01:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49673 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0DPEBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LqXRZPXhL3ZHEKokm1vHp/M6ErqfCxFebCn3H/XC6OG40RgZSUY8IcrRGPevy4JZRM
         4Lv3Ei8qIg81kKR+oRnSZJji8UMKqi9Qo9o9djqH3KhbAqNSAsg+wSZaD5UJdOS5IXSX
         dJOVaDarw/6H3R2SheICF+PVZ2Iy4IbhHuC/w=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
	 <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
	 <20100415210357.GG5069@nowhere>
	 <k2u40ec3ea41004151445je53e7ef2u5c0e48e038e4efca@mail.gmail.com>
	 <alpine.LFD.2.00.1004160051390.3625@localhost.localdomain>
	 <p2n40ec3ea41004151627u11ca4d7dw46cbd6b58df9f1c8@mail.gmail.com>
	 <alpine.LFD.2.00.1004160138200.3625@localhost.localdomain>
	 <alpine.LFD.2.00.1004160204510.3625@localhost.localdomain>
Date: Thu, 15 Apr 2010 21:01:46 -0700
X-Google-Sender-Auth: a117299bbb773186
Message-ID: <i2z40ec3ea41004152101gd55713f2w9eadd8d5ea721688@mail.gmail.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 5:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 16 Apr 2010, Thomas Gleixner wrote:
>> BTW, if interacting with grub is that hard: how does an user start the
>> tracer at all ?
>
> Just looked through the other patches and noticed that the patch which
> provides the tracing_off(level) stuff is incomplete as it provides
> only a command line option to change that tracing off level.
>
> The command line option is merily for tracing which happens to be
> started on the command line i.e. _BEFORE_ we have usable user space.
>
> So your grub argument is just crap. If the user cannot change this
> setting w/o fiddling with the obscured grub then he can not start the
> tracer on the command line either.
>
> But somehow he can start the tracer later when user space is up and
> running, but there is no way to change that setting anymore. Therefor
> you go through the kernel and impose settings at will.
>
> 1) Your patch simply lacks an interface to change that setting via
>   debugfs/tracing/wtf
>
>   WTF should I reboot my machine to change that setting from the
>   default BUG to WARN or NONE ? There is no reason at all.

You're right, this should be something that may be changed at run
time. I spoke with Steven at LCS and he agrees that there should be an
option in (debugfs)/tracing/options/ for this. I will fix up the first
patch to include this.

> 2) tracing off can be done via filters on functions and/or events
>   already - so I doubt that the tracing_off_event(level) is necessary
>   at all.
>
>   schedule_bug() definitely deserves a separate trace_schedule_bug()
>   event which can be used to stop the tracer by already existing
>   functionality.

Steven said he would be fine with a separate TRACE_EVENT_<blah> macro
for the schedule bug if needed, but I'm not sure we need to go that
far. If it's configurable through debugfs at run time then it serves
my purpose. Unless you feel we should have finer grained control
specifically for scheduling while atomic bugs, I'll just leave it as
TRACE_EVENT_WARN.

-- Chase
