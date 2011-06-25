Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab1FYNKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 09:10:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:33725 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1FYNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 09:10:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: random(4) driver questions
Date: Sat, 25 Jun 2011 13:53:59 +0100
Message-ID: <7c2hd8-j3t.ln1@chipmunk.wormnet.eu>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sandy Harris <sandyinchina@gmail.com> wrote:
> 
> One problem they pointed out is that there may be little entropy 
> available on a Linux-based router; no keyboard or mouse, solid state 
> storage so no disk entropy, and an enemy might observe network 
> activity, so network interrupts give little or no useful entropy.
> 
I vaguely recall network interrupts (anything that can be externally 
influenced) can be snooped upon so their use is discouraged.  Turns out 
IRQF_SAMPLE_RANDOM is scheduled for destruction, 
Documentation/feature-removal-schedule.txt.

> The only in-kernel solution I can think of would be to add something 
> in the system call interface to make very system call throw timing 
> information into the pool. I very much doubt, though, that that is a 
> good idea. What do others think, and does anyone have a better idea?
> 
An option I used, no idea if it safe though, for my headless colo box 
that seemed to always be running out of entropy was use a sleep() timing 
daemon:

http://www.vanheusden.com/te/

There was no chance of me using the ALSA/video4linux approach also on 
that site as I had a SPARC server so it was my only real choice.  Seems 
to work well, but had to apply a patch to stop it insanely spinning the 
CPU un-necessarily (the author unfortunately never responded):

http://stuff.digriz.org.uk/timer-select.diff

Another tool I found in my travels was HAVEGE:

http://www.irisa.fr/caps/projects/hipsor/index.php

Again, no idea if this is a good idea.

Of course in the VM world, the timer approach probably would work.

Cheers

-- 
Alexander Clouter
.sigmonster says: Some people only open up to tell you that they're closed.

