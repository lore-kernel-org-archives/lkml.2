Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2CZOcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:32:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53663 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2CZOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:32:10 -0400
Date: Mon, 26 Mar 2012 16:32:50 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tony Vroon <tony@linx.net>
Cc: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        daniel@ffwll.ch
Subject: Re: [git pull] drm main pull for 3.4-rc1
Message-ID: <20120326143250.GN4014@phenom.ffwll.local>
Mail-Followup-To: Tony Vroon <tony@linx.net>,
	Dave Airlie <airlied@linux.ie>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie>
 <4F70764F.7030409@linx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F70764F.7030409@linx.net>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:59:43PM +0100, Tony Vroon wrote:
> On 21/03/12 10:47, Dave Airlie wrote:
> > i915: re-enabling GMBUS, finish gpu patch (might help hibernation who 
> > knows), missed irq fixes, stencil tiling fixes, interlaced support, 
> > aliasesd PPGTT support for SNB/IVB, swizzling for SNB/IVB, semaphore fixes
> 
> This causes an eventual (after barely a minute of use) lockup that I can
> not recover from on my Lifebook S761. It does not switch to a text
> console for me, but by stopping my graphical login manager (slim) early
> I got this:
> DRHD: handling fault status reg 3
> DMAR:[DMA Write] Request device [00:02.0] fault addr 12806b000
> DMAR:[fault reason 05] PTE Write access is not set
> DRHD: handling fault status reg 3
> DMAR:[DMA Write] Request device [00:02.0] fault addr 128183000
> DMAR:[fault reason 05] PTE Write access is not set
> DRHD: handling fault status reg 3
> DMAR:[DMA Write] Request device [00:02.0] fault addr 4147562000
> DMAR:[fault reason 05] PTE Write access is not set
> DRHD: handling fault status reg 3
> DMAR:[DMA Write] Request device [00:02.0] fault addr 4147562000
> DMAR:[fault reason 05] PTE Write access is not set
> 
> (The full dmesg is attached so you can see it in context)
> In the interest of full disclosure, this is a dual-screen setup:
> Screen 0: minimum 320 x 200, current 1680 x 1818, maximum 8192 x 8192
> LVDS1 connected 1366x768+0+1050 (normal left inverted right x axis y
> axis) 293mm x 165mm
> HDMI2 connected 1680x1050+0+0 (normal left inverted right x axis y axis)
> 459mm x 296mm
> 
> To confirm, that is the i915 graphics:
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core
> Processor Family Integrated Graphics Controller (rev 09) (prog-if 00
> [VGA controller])
> 	Subsystem: Fujitsu Limited. Device 15e9
> 	Flags: bus master, fast devsel, latency 0, IRQ 42
> 	Memory at e0000000 (64-bit, non-prefetchable) [size=4M]
> 	Memory at d0000000 (64-bit, prefetchable) [size=256M]
> 	I/O ports at 3000 [size=64]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
> 	Capabilities: [d0] Power Management version 2
> 	Capabilities: [a4] PCI Advanced Features
> 	Kernel driver in use: i915
> 
> Please let me know if you want a full lspci, and what your favourite
> options are. I am back on a Thursday git snapshot now, which runs fine:
> Linux adrastea 3.3.0-04074-g5375871 #1 SMP PREEMPT Thu Mar 22 09:27:24
> GMT 2012 x86_64 Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz GenuineIntel
> GNU/Linux

Ok, this is ugly. Do you have any special module options for i915 set
(like i915_enable_rc6)? Also, can you check whether disabling vt-d does
work around the issue? Last but not least, can you please bisect where
this regression got introduced so we have an idea why it breaks?

Thanks a lot,

Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
