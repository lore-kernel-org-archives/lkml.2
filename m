Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0GLUZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:25:06 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:34917 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0GLUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:25:04 -0400
X-Greylist: delayed 2338 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2010 16:25:04 EDT
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de>
From: Nix <nix@esperi.org.uk>
Emacs: anything free is worth what you paid for it.
Date: Mon, 12 Jul 2010 20:46:01 +0100
In-Reply-To: <201007110918.42120.Martin@lichtvoll.de> (Martin Steigerwald's message of "11 Jul 2010 08:18:55 +0100")
Message-ID: <87mxtwtreu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Jul 2010, Martin Steigerwald said:

> 2.6.34 was a desaster for me: bug #15969 - patch was availble before 
> 2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as well 
> as most important two complete lockups - well maybe just X.org and radeon 
> KMS, I didn't start my second laptop to SSH into the locked up one - on my 
> ThinkPad T42. I fixed the first one with the patch, but after the lockups I 
> just downgraded to 2.6.33 again.
[...]
> hang on hibernation with kernel 2.6.34.1 and TuxOnIce 3.1.1.1
>
> on this mailing list just a moment ago. But then 2.6.33 did hang with 
> TuxOnIce which apparently (!) wasn't a TuxOnIce problem either, since 
> 2.6.34 did not hang with it anymore which was a reason for me to try 
> 2.6.34 earlier.

To introduce yet more anecdata into this thread, I too had problems with
TuxOnIce-driven suspend/resume from just post-2.6.32 to just pre-2.6.34.
The solution was, surprise surprise, to *raise a bug report*, whereupon
in short order I had a workaround. In 2.6.34, the problem vanished as
mysteriously as it appeared, as did the bug whereby X coredumped and the
screen stayed dark forever upon quitting X. 2.6.34 and 2.6.34.1 have
worked better for me than any kernel I've used since 2.6.30, with no
bugs noticeable on any of my machines (that's a first since 2.6.26).

I speculate that there may be some subtle piece of overwriting inside
the Radeon KMS and/or DRM code, which is obscure enough that it is
relatively easily perturbed by changes elsewhere in the kernel.

But nonetheless, one cannot extrapolate from a single bug in a subsystem
as complex as DRM/KMS to the quality of the entire kernel. This is
doubly true given the degree of difference between different cards
labelled as Radeons: I'd venture to state that most of the Radeon bugs
I've seen flow past over the last year or so only affect a small subset
of cards: but if you add them all up, it's likely that most users have
been bitten by at least one. But the problem here is not the kernel
developers, nor the kernel quality: it's that ATI Radeons are a
horrifically complicated and tangled web of slightly variable hardware.
(In this they are no different from any other modern graphics card.)


Martin, might I suggest considering stable kernels 'experimental' until
at least .1 is out? Before Linus releases a kernel, its only users are
dedicated masochists and developers: after the release, piles of regular
early adopters pour in, and heaps of bug reports head to lkml and fixes
head to -stable. The .1 kernels, with fixes for some of those, are the
first you can really call *stable*, as they've got fixes for bugs
isolated after testing by a much larger userbase of suckers.

  -- N., dedicated sucker and masochist
