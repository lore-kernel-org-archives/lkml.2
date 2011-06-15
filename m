Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1FOUZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:25:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1FOUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:25:09 -0400
From: Martin <marogge@onlinehome.de>
To: "vger.kernel.org, " <linux-kernel@vger.kernel.org>, wzab@ise.pw.edu.pl
Subject: Re: Kernel panic on HT machine - maybe i915 related?
Date: Wed, 15 Jun 2011 22:24:34 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39.1-ck2; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106152224.34487.marogge@onlinehome.de>
X-Provags-ID: V02:K0:oWoeUl4dRFRyXGfWKfKmMEFDaLwgnGPpB83j6KWUzxc
 QypasYBCFadmsZt1775uICXcXuOD2LRu/C3O1Ni3KQ+XKwZp+A
 oNmEZtXja6GhWOm3g3Wb6PFXRcXVlwOR2+Mm3yKoFJENHa6anR
 /NrinVU0lEvp5ee+pAVgR13vgLVuKSDZr81RSNM/8OiMg6WLLe
 MquN48uHSKL9E2O50chng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wzab wrote:

> Hi,
> I tried to find the source of the problem I experience, supposing, that
> it may affect also other users of machine with Hyper-Threaded CPU.
> [...]

Hi wzab et al, 

only today I have started to use a spare machine at work, with a hyperthreaded 
CPU (P4 3.2GHz). I also experience random kernel panics with 2.6.39.1 and 
SMP/HT enabled. The machine usually runs for a couple of hours before the 
panic occurs.

> Crash seems to happen in random places:
> [...]

Same here, although my panics look different from yours. In both cases I had a 
lot of hardware interrupts on the stack trace but no kmemcheck. I only 
remembered to take a photo with my mobile phone the second time. The stack 
trace contains handle_*irq*, tg3, ata_bmdma, __ata_sff, i915, drm_vblank_put, 
intel_thermal, try_preempt, resched*, drm_vblank_put, do_invalid_op, oops_end, 
do_bounds, panic. The EIP is drm_vblank_put+0x13/0x50.

Could this be an i915 issue with 2.6.39.1? At home I have two other machines 
on i915 but with different chipsets that run fine with the same kernel.

> As crash occurs only with HT on and doesn't happen on another machine
> with 2 cores, it seems that maybe the problem is associated with
> incorrect allocation of resources or locking for HT enabled CPU...

I do not observe the issue with the regular non-SMP 2.6.38.7 distro kernel, so 
it might be HT related. Truth be told I need to investigate further since my 
2.6.39.1 kernel is patched. In the meantime, if someone recognizes the issue 
please come forward.

Thanks and regards,

Martin
