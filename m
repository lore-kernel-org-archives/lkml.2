Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1EYTEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:04:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55717 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1EYTEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:04:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110525205707.12abc68c@neptune.home>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
	<20110525181917.12cf97b8@neptune.home>
	<BANLkTimxi-LZFzwv=z6RRBCX098hr-ViUg@mail.gmail.com>
	<20110525204648.58983270@neptune.home>
	<BANLkTi=207-bVi3pnOWk7zG61u4=YU4GFg@mail.gmail.com>
	<20110525205707.12abc68c@neptune.home>
Date: Wed, 25 May 2011 21:04:45 +0200
X-Google-Sender-Auth: AjDD1fQ2SEB6Gol2zEVbsmKY35U
Message-ID: <BANLkTimtYvcN8kj+jnaKHNGmN36YvMt7Rg@mail.gmail.com>
Subject: Re: [PATCH] fbmem: fix race condition between register_framebuffer()
 and fb_open()
From: Fabio Erculiani <lxnay@sabayon.org>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:57 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
>> On Wed, May 25, 2011 at 8:46 PM, Bruno Prémont wrote:
>> > On Wed, 25 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
>> >> I'm not a fbdev expert. So I leave the real fix to real men ( ;-) ).
>> >> It is causing deadlock during boot, so I would consider it quite critical.
>> >> Users using any fb driver will get into troubles.
>> >> The workaround is to boot with vga=normal.
>> >
>> > What is your system doing during boot? I've never seen it here but maybe
>> > my boot sequence is too simple.
>>
>> I'm using vesafb and vga=791. It is quite simple to reproduce.
>> Also see: http://bugs.gentoo.org/show_bug.cgi?id=368109
>
> Looks like gentoo kernel, might be splash is related to the hang

Then, if you say so, it must be the fbsplash patch for sure, I keep
forgetting of that :-/

>
>> > Could you tell if it deadlocks before init gets started or afterwards,
>> > which fb drivers (and extra kernel patches if any) are in use.
>>
>> Exactly when register_framebuffer() is called, in my case, early in
>> the boot phase, before init.
>>
>> >
>> > If you have the complete backtrace of the deadlocked processes it would
>> > help getting a better idea of what is affected and how (and why just the
>> > framebuffer's lock is not causing trouble with earlier kernel versions).
>>
>> Because that code got a HUGE rewrite in the latest cycle, where
>> registration_lock has been introduce.
>> Just make a diff between 2.6.38 and 2.6.39. It will be easy to see
>> that SO MANY lines have changed ;-)
>> Anyway, since I'm out of office these days, I won't be able to send
>> you the traceback this week, but since so many people have run into
>> it, I guess it's fairly simple to reproduce.
>
> Rewrite was not so huge, and I'm not affected here (running with KMS
> compiled in though and vanilla kernel).
> Probably the cause is related to one of the extra patches provided by
> Gentoo and subscribing to framebuffer registration notifications.
>
> Will have a look.

Thanks a lot, let me know if I can help out next week.

>
> Bruno
>



-- 
Fabio Erculiani
