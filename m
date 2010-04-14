Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0DNPfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:35:22 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47816 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166Ab0DNPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:35:21 -0400
Date: Wed, 14 Apr 2010 11:35:20 -0400
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Martin Teufel <teufel@informatik.uni-frankfurt.de>,
       linux-kernel@vger.kernel.org
Subject: Re: AMD Geode LX WDT (geode-mfgpt)
Message-ID: <20100414153520.GB4309@caffeine.csclub.uwaterloo.ca>
References: <20100331045414.GA3241@hekate.rbi.informatik.uni-frankfurt.de> <4BB30304.7060300@nets.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB30304.7060300@nets.rwth-aachen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:08:36AM +0200, Arnd Hannemann wrote:
> Am 31.03.2010 06:54, schrieb Martin Teufel:
> 
> > I have some ALIX boards (SBC) with AMD Geode LX CPUs and their companion
> > device CS5536 and am using Debian on them. I didn't care about the
> > integrated watchdog timer (in the CS5536) so far. Recently I did, but
> > neither the CONFIG_GEODE_WDT was set in the debian kernel (2.6.26), nor
> > the CONFIG_GEODE_MFGPT_TIMER. So I compiled my own debian 2.6.26 geode
> > kernel (CONFIG_MGEODE_LX=y, CONFIG_GEODE_WDT=y,
> > CONFIG_GEODE_MFGPT_TIMER=y, CONFIG_CRYPTO_DEV_GEODE=y etc.).
> > 
> > My problem is that the geode-mfgpt doesn't find any timers:
> > 
> > [    0.204012] geode-mfgpt:  0 MFGPT timers available.
> > [    0.208013] mfgpt-timer:  Could not allocate a MFPGT timer
> > ...
> > [    2.284029] geodewdt:  No timers were available
> > 
> > My question is: Why doesn't it? Is this a known bug? If so, is it
> > already fixed in a newer kernel version?
> 
> Your BIOS may already use all available timers.
> AFAIR only TinyBios with ALIX leaves timers for the OS.
> Award and CoreBoot both use them all.

The BIOS on the CompuLab CM-iGLX modules leave 5 timers available as
far as I recall.  We certainly haven't had any issue getting one for a
watchdog on those modules.  The BIOS happens to be a buggy ancient piece
of crap in other ways, but at least its OK for the timer use.

It is unfortunately an amazingly stupid timer design (there is no way to
clear a timer when you are done using it to indicate others can use it).
We had to hack the driver a bit to allow using timers already in use
given we actually start the watchdog from the bootloader and have the
kernel watchdog driver take over later.

-- 
Len Sorensen
