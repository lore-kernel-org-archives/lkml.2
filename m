Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1KBOSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:18:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1KBOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:18:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/13 (12)] arm-soc updates
Date: Wed, 2 Nov 2011 15:18:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111020322.46469.arnd@arndb.de> <CA+55aFzCyQ1fyTs5ZbcGD_gCVX0oA99NiLEsxMtJ1h9xf_-v9A@mail.gmail.com>
In-Reply-To: <CA+55aFzCyQ1fyTs5ZbcGD_gCVX0oA99NiLEsxMtJ1h9xf_-v9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021518.05477.arnd@arndb.de>
X-Provags-ID: V02:K0:cAvwQ88GincVx7H4+4n0gqUPx0utpAbjh8w4kTUBTvK
 5yTlMW0twoQN049mMF2y3OEX4LwAKdftyzFTUxeeaj+rMHaVgA
 O6b2UmUnldV1j3v6zGVWxZwUET5zmyFRMOwdqoem+DzwXtFDV7
 1UwrqFOOwu+jZ4PvfrmzH5wLjSE+ivh0jz3tsgCHMnvGeOr0k/
 tj2Lbbvp8xsRgW7PYSWz7hlkHFHlqNaVtnW/SUGb6zNUJqakEh
 JN6Q4g+igm39fRZNcjZkTg0vxgVhscRcOaoyFfGfr1OQHM9cyK
 yK5QRDsFdFseICP4rIst/NJq7trWzY4O7LjVMJJytvxkXM7+qD
 oG8E6XkRxZip/UAjxCD0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 November 2011, Linus Torvalds wrote:
> On Tue, Nov 1, 2011 at 7:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > I have a series of 12 pull requests for the arm-soc tree, a total of 409
> > non-merge commits. Feel free to pull either the for-linus branch that contains
> > the lot with all conflicts resolved or the individual pull requests.
> 
> Ok, I did the individual merges, because I really want to know what
> horrible things go on there. Ugh.
>
> But I did compare it against your pre-merged thing, and there are some
> differences. I think my version of the arch/arm/mach-omap2/Makefile
> thing is better, for example (you seem to have the OMAP4_PANDA and
> OMAP3517EVM boards duplicated). And the arch/arm/plat-omap/devices.c
> difference is just a matter of taste.

Right, your version looks better in both cases.

> But the arch/arm/mach-omap2/board-generic.c difference is real. You
> left a lot more header file includes in place, while my merge looked
> at the previous commits and merges that removed a lot of them - and
> followed suit. Maybe there was some reason you didn't?

I've done this merge a few times. I think at one point I got it right,
but the version I had in my combined branch used an earlier merge
that got back through rerere. I'll try to watch out for these in the
future.

> Also, your tree removed the atag_offset lines that weren't even content
> conflicts, and again, there may have been some reason for that?

This one was intentional, but it's not very important either. The
conflict was between 5e52b435b "ARM: mach-omap2: convert boot_params
to atag_offset" and 8d61649 "ARM: OMAP2+: board-generic: Add DT support
to generic board" and . The first one changed the method how to
find the traditional "atag" data structure, the second patch moved
the file over from having one atag (and board number) based entry
to having three distinct device tree based machine descriptions, which
obsoletes the atag_offset/boot_params.

I had originally merged them incorrectly and it seems that this mismerge
ended up in your tree now. It's harmless because the atag_offset is
ignored here, but I'll send a cleanup after checking all other files
that may have the same problem.

	Arnd
