Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab0I0Sxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:53:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757124Ab0I0Sxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:53:52 -0400
Date: Mon, 27 Sep 2010 11:52:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <cl@linux.com>, David Airlie <airlied@linux.ie>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linux Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: DRM-related kmalloc-32 memory leak in 2.6.35
Message-Id: <20100927115207.633024b1.akpm@linux-foundation.org>
In-Reply-To: <1282769949.3007.7.camel@calx>
References: <alpine.DEB.2.00.1008221615350.29062@chino.kir.corp.google.com>
	<1282623994.10679.921.camel@calx>
	<alpine.DEB.2.00.1008232134480.25742@chino.kir.corp.google.com>
	<1282663241.10679.958.camel@calx>
	<alpine.DEB.2.00.1008241036250.344@router.home>
	<1282769949.3007.7.camel@calx>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 15:59:09 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Tue, 2010-08-24 at 10:37 -0500, Christoph Lameter wrote:
> > On Tue, 24 Aug 2010, Matt Mackall wrote:
> > 
> > > kmalloc-32        1113344 1113344     32  128    1 : tunables    0    0
> > > 0 : slabdata   8698   8698      0
> > >
> > > That's /proc/slabinfo on my laptop with SLUB. It looks like my last
> > > reboot popped me back to 2.6.33 so it may also be old news, but I
> > > couldn't spot any reports with Google.
> > 
> > Boot with "slub_debug" as a kernel parameter
> > 
> > and then do a
> > 
> > cat /sys/kernel/slab/kmalloc-32/alloc_calls
> > 
> > to find the caller allocating the objets.
> 
> Still present in 2.6.35. Appears to be DRM:
> 
>     845 drm_vm_open_locked+0x72/0x109 age=43/37572/59269 pid=2089
> cpus=0-1
> 
> That's after about a minute of uptime. Grows to 100k in about a day.
> 
> dmesg bits:
> [    0.834653] [drm] Initialized drm 1.1.0 20060810
> [    0.834986] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.834995] pci 0000:00:02.0: setting latency timer to 64
> [    1.002572] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
> [    1.002580] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    1.019880] acpi device:03: registered as cooling_device2
> [    1.021520] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> [    1.021543] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    1.021855] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> This is with:
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 03)
> 

Matt tells me that this (drop-dead box-killing!) bug is still present
in current kernels.  Could someone take a look please?

The code seems very simple, and I couldn't spot a problem.  Probably
this means that I'm even simpler.

