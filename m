Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab0I0UkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:40:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab0I0UkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:40:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gpMNCju+bnMk3orCURX0Eo6BZiNTXcoGzmoKt/kGTfzYS9N1Qd3NgNbHQZITpdXMe
	JJyz5/6rguJiOc0DCm2lQ==
Date: Mon, 27 Sep 2010 13:40:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <cl@linux.com>,
        David Airlie <airlied@linux.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: DRM-related kmalloc-32 memory leak in 2.6.35
In-Reply-To: <20100927115207.633024b1.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1009271335290.21226@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008221615350.29062@chino.kir.corp.google.com> <1282623994.10679.921.camel@calx> <alpine.DEB.2.00.1008232134480.25742@chino.kir.corp.google.com> <1282663241.10679.958.camel@calx> <alpine.DEB.2.00.1008241036250.344@router.home>
 <1282769949.3007.7.camel@calx> <20100927115207.633024b1.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Andrew Morton wrote:

> > Still present in 2.6.35. Appears to be DRM:
> > 
> >     845 drm_vm_open_locked+0x72/0x109 age=43/37572/59269 pid=2089
> > cpus=0-1
> > 
> > That's after about a minute of uptime. Grows to 100k in about a day.
> > 
> > dmesg bits:
> > [    0.834653] [drm] Initialized drm 1.1.0 20060810
> > [    0.834986] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > [    0.834995] pci 0000:00:02.0: setting latency timer to 64
> > [    1.002572] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> > [    1.002580] [drm] MTRR allocation failed.  Graphics performance may suffer.
> > [    1.019880] acpi device:03: registered as cooling_device2
> > [    1.021520] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> > [    1.021543] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> > [    1.021855] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> > 
> > This is with:
> > 
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> > Integrated Graphics Controller (rev 03)
> > 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
> > Integrated Graphics Controller (rev 03)
> > 
> 
> Matt tells me that this (drop-dead box-killing!) bug is still present
> in current kernels.  Could someone take a look please?
> 
> The code seems very simple, and I couldn't spot a problem.  Probably
> this means that I'm even simpler.
> 

I'm wondering what reading /sys/kernel/debug/dri/.../vma says when 
DRM_DEBUG_CODE is enabled, it seems to have been written for this type of 
debugging.
