Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0KZJYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:24:21 -0500
Received: from ist.d-labs.de ([213.239.218.44]:46313 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab0KZJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:24:19 -0500
Date: Fri, 26 Nov 2010 10:23:41 +0100
From: Florian Mickler <florian@mickler.org>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: kernel 2.6.37-rc2 breaks i915 graphics
Message-ID: <20101126102341.6d4188af@schatten.dmk.lab>
In-Reply-To: <20101121183423.0f7c1872@laptop.homenet>
References: <20101121102344.7c590b99@laptop.homenet>
	<0d30dc$k822nk@orsmga001.jf.intel.com>
	<20101121183423.0f7c1872@laptop.homenet>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 18:34:23 +0000
Chris Vine <chris@cvine.freeserve.co.uk> wrote:

> On Sun, 21 Nov 2010 10:30:43 +0000
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > On Sun, 21 Nov 2010 10:23:44 +0000, Chris Vine
> > <chris@cvine.freeserve.co.uk> wrote:
> > > Hi,
> > > 
> > > With kernel 2.6.37-rc2, i915 graphics usually fails on boot-up after
> > > modesetting with my Lenovo S12 netbook which uses the Intel 945GME
> > > Express Integrated Graphics Controller.  It displays up to the
> > > point at which modesetting takes place and then usually goes blank.
> > > 
> > > There may be some kind of race at work here: first, sometimes
> > > (maybe 1 times in 4) graphics comes up correctly on a first cold
> > > boot, but I have never managed to get it to come up on a warm
> > > reboot. Secondly, graphics can be restored when I know (but cannot
> > > see) that boot-up has concluded, simply by suspending the laptop
> > > and then resuming.  Resuming the laptop after a suspend always
> > > brings up the graphics correctly.
> > 
> > Add drm.debug=0xe to your boot commandline and compare if there is any
> > difference between a successful cold boot, a broken cold boot and a
> > warm boot. Similarly, comparing the output of intel_reg_dumper after
> > each should yield a few clues as to what stage in the boot process we
> > fail. -Chris
> 
> First an additional datum point: 2.6.37-rc1 works normally, so the bug
> is something introduced between 2.6.37-rc1 and 2.6.37-rc2 (to that
> extent it may be related to this bug which reports a similar phenomenon:
> http://lkml.org/lkml/2010/11/21/23 ).
> 
> Attached is the dmesg output from a successful cold boot with
> 2.6.37-rc2, an unsuccessful cold boot and an unsuccessful warm boot,
> each with drm.debug=0xe.
> 

I trimmed the failure boot logs to the stuff before suspending, in
order to only compare the boot sequence. 

Looks like only in failure case there are "pipe b
underrun" reported...
In success case, no "pipe b underrun" is reported. 

Also in success case connectors are probed much more often:

$ grep drm:drm_helper_probe_single_connector_modes dmesg-2.6.37-rc2.succeed  | wc -l
76
$ grep drm:drm_helper_probe_single_connector_modes dmesg-2.6.37-rc2.*.fail  | wc -l
32
$ grep drm:drm_helper_probe_single_connector_modes dmesg-2.6.37-rc2.cold.fail  | wc -l
16


I could not spot any other differences both failure modes have in common against the success case.

If Chris (Wilson) doesn't yet know what could be the bug a bisection 
between 2.6.37-rc1 and rc2 might be helpful. 

 
> I can't provide the output of intel_reg_dumper:  I can't compile the
> latest intel-gpu-tools from git (missing declaration/definition of
> I915_EXE_BLT).  Probably something in a relevant library is too old.
> 
> Chris
> 
