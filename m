Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2K2UsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:48:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34432 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab2K2UsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:48:20 -0500
Date: Thu, 29 Nov 2012 21:49:35 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
        frankyl@broadcom.com, kanyan@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, srinidhi.kasagar@stericsson.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH 2/6] i915: convert struct spinlock to spinlock_t
Message-ID: <20121129204935.GA4384@phenom.ffwll.local>
Mail-Followup-To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	backports@vger.kernel.org, alexander.stein@systec-electronic.com,
	brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
	frankyl@broadcom.com, kanyan@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
 <1354221910-22493-3-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354221910-22493-3-git-send-email-mcgrof@do-not-panic.com>
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:45:06PM -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> spinlock_t should always be used.
> 
>   LD      drivers/gpu/drm/i915/built-in.o
>   CHECK   drivers/gpu/drm/i915/i915_drv.c
>   CC [M]  drivers/gpu/drm/i915/i915_drv.o
>   CHECK   drivers/gpu/drm/i915/i915_dma.c
>   CC [M]  drivers/gpu/drm/i915/i915_dma.o
>   CHECK   drivers/gpu/drm/i915/i915_irq.c
>   CC [M]  drivers/gpu/drm/i915/i915_irq.o
>   CHECK   drivers/gpu/drm/i915/i915_debugfs.c
> drivers/gpu/drm/i915/i915_debugfs.c:558:31: warning: dereference of noderef expression
> drivers/gpu/drm/i915/i915_debugfs.c:558:39: warning: dereference of noderef expression
> drivers/gpu/drm/i915/i915_debugfs.c:558:51: warning: dereference of noderef expression
> drivers/gpu/drm/i915/i915_debugfs.c:558:63: warning: dereference of noderef expression
>   CC [M]  drivers/gpu/drm/i915/i915_debugfs.o
>   CHECK   drivers/gpu/drm/i915/i915_suspend.c
>   CC [M]  drivers/gpu/drm/i915/i915_suspend.o
>   CHECK   drivers/gpu/drm/i915/i915_gem.c
> drivers/gpu/drm/i915/i915_gem.c:3703:14: warning: incorrect type in assignment (different base types)
> drivers/gpu/drm/i915/i915_gem.c:3703:14:    expected unsigned int [unsigned] [usertype] mask
> drivers/gpu/drm/i915/i915_gem.c:3703:14:    got restricted gfp_t
> drivers/gpu/drm/i915/i915_gem.c:3706:22: warning: invalid assignment: &=
> drivers/gpu/drm/i915/i915_gem.c:3706:22:    left side has type unsigned int
> drivers/gpu/drm/i915/i915_gem.c:3706:22:    right side has type restricted gfp_t
> drivers/gpu/drm/i915/i915_gem.c:3707:22: warning: invalid assignment: |=
> drivers/gpu/drm/i915/i915_gem.c:3707:22:    left side has type unsigned int
> drivers/gpu/drm/i915/i915_gem.c:3707:22:    right side has type restricted gfp_t
> drivers/gpu/drm/i915/i915_gem.c:3711:39: warning: incorrect type in argument 2 (different base types)
> drivers/gpu/drm/i915/i915_gem.c:3711:39:    expected restricted gfp_t [usertype] mask
> drivers/gpu/drm/i915/i915_gem.c:3711:39:    got unsigned int [unsigned] [usertype] mask
>   CC [M]  drivers/gpu/drm/i915/i915_gem.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_context.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_context.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_debug.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_debug.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_evict.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_evict.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_execbuffer.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_execbuffer.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_gtt.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_gtt.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_stolen.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_stolen.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_tiling.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_tiling.o
>   CHECK   drivers/gpu/drm/i915/i915_sysfs.c
>   CC [M]  drivers/gpu/drm/i915/i915_sysfs.o
>   CHECK   drivers/gpu/drm/i915/i915_trace_points.c
>   CC [M]  drivers/gpu/drm/i915/i915_trace_points.o
>   CHECK   drivers/gpu/drm/i915/intel_display.c
> drivers/gpu/drm/i915/intel_display.c:1736:9: warning: mixing different enum types
> drivers/gpu/drm/i915/intel_display.c:1736:9:     int enum transcoder  versus
> drivers/gpu/drm/i915/intel_display.c:1736:9:     int enum pipe
> drivers/gpu/drm/i915/intel_display.c:3659:48: warning: mixing different enum types
> drivers/gpu/drm/i915/intel_display.c:3659:48:     int enum pipe  versus
> drivers/gpu/drm/i915/intel_display.c:3659:48:     int enum transcoder
>   CC [M]  drivers/gpu/drm/i915/intel_display.o
>   CHECK   drivers/gpu/drm/i915/intel_crt.c
>   CC [M]  drivers/gpu/drm/i915/intel_crt.o
>   CHECK   drivers/gpu/drm/i915/intel_lvds.c
>   CC [M]  drivers/gpu/drm/i915/intel_lvds.o
>   CHECK   drivers/gpu/drm/i915/intel_bios.c
> drivers/gpu/drm/i915/intel_bios.c:706:60: warning: incorrect type in initializer (different address spaces)
> drivers/gpu/drm/i915/intel_bios.c:706:60:    expected struct vbt_header *vbt
> drivers/gpu/drm/i915/intel_bios.c:706:60:    got void [noderef] <asn:2>*vbt
> drivers/gpu/drm/i915/intel_bios.c:726:42: warning: incorrect type in argument 1 (different address spaces)
> drivers/gpu/drm/i915/intel_bios.c:726:42:    expected void const *<noident>
> drivers/gpu/drm/i915/intel_bios.c:726:42:    got unsigned char [noderef] [usertype] <asn:2>*
> drivers/gpu/drm/i915/intel_bios.c:727:40: warning: cast removes address space of expression
> drivers/gpu/drm/i915/intel_bios.c:738:24: warning: cast removes address space of expression
>   CC [M]  drivers/gpu/drm/i915/intel_bios.o
>   CHECK   drivers/gpu/drm/i915/intel_ddi.c
> drivers/gpu/drm/i915/intel_ddi.c:87:6: warning: symbol 'intel_prepare_ddi_buffers' was not declared. Should it be static?
> drivers/gpu/drm/i915/intel_ddi.c:1036:34: warning: mixing different enum types
> drivers/gpu/drm/i915/intel_ddi.c:1036:34:     int enum pipe  versus
> drivers/gpu/drm/i915/intel_ddi.c:1036:34:     int enum transcoder
>   CC [M]  drivers/gpu/drm/i915/intel_ddi.o
> drivers/gpu/drm/i915/intel_ddi.c: In function ‘intel_ddi_setup_hw_pll_state’:
> drivers/gpu/drm/i915/intel_ddi.c:1129:2: warning: ‘port’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> drivers/gpu/drm/i915/intel_ddi.c:1111:12: note: ‘port’ was declared here
>   CHECK   drivers/gpu/drm/i915/intel_dp.c
>   CC [M]  drivers/gpu/drm/i915/intel_dp.o
>   CHECK   drivers/gpu/drm/i915/intel_hdmi.c
>   CC [M]  drivers/gpu/drm/i915/intel_hdmi.o
>   CHECK   drivers/gpu/drm/i915/intel_sdvo.c
>   CC [M]  drivers/gpu/drm/i915/intel_sdvo.o
>   CHECK   drivers/gpu/drm/i915/intel_modes.c
>   CC [M]  drivers/gpu/drm/i915/intel_modes.o
>   CHECK   drivers/gpu/drm/i915/intel_panel.c
>   CC [M]  drivers/gpu/drm/i915/intel_panel.o
>   CHECK   drivers/gpu/drm/i915/intel_pm.c
> drivers/gpu/drm/i915/intel_pm.c:2173:1: warning: symbol 'mchdev_lock' was not declared. Should it be static?
>   CC [M]  drivers/gpu/drm/i915/intel_pm.o
>   CHECK   drivers/gpu/drm/i915/intel_i2c.c
>   CC [M]  drivers/gpu/drm/i915/intel_i2c.o
>   CHECK   drivers/gpu/drm/i915/intel_fb.c
>   CC [M]  drivers/gpu/drm/i915/intel_fb.o
>   CHECK   drivers/gpu/drm/i915/intel_tv.c
>   CC [M]  drivers/gpu/drm/i915/intel_tv.o
>   CHECK   drivers/gpu/drm/i915/intel_dvo.c
>   CC [M]  drivers/gpu/drm/i915/intel_dvo.o
>   CHECK   drivers/gpu/drm/i915/intel_ringbuffer.c
>   CC [M]  drivers/gpu/drm/i915/intel_ringbuffer.o
>   CHECK   drivers/gpu/drm/i915/intel_overlay.c
>   CC [M]  drivers/gpu/drm/i915/intel_overlay.o
>   CHECK   drivers/gpu/drm/i915/intel_sprite.c
>   CC [M]  drivers/gpu/drm/i915/intel_sprite.o
>   CHECK   drivers/gpu/drm/i915/intel_opregion.c
>   CC [M]  drivers/gpu/drm/i915/intel_opregion.o
>   CHECK   drivers/gpu/drm/i915/dvo_ch7xxx.c
>   CC [M]  drivers/gpu/drm/i915/dvo_ch7xxx.o
>   CHECK   drivers/gpu/drm/i915/dvo_ch7017.c
>   CC [M]  drivers/gpu/drm/i915/dvo_ch7017.o
>   CHECK   drivers/gpu/drm/i915/dvo_ivch.c
>   CC [M]  drivers/gpu/drm/i915/dvo_ivch.o
>   CHECK   drivers/gpu/drm/i915/dvo_tfp410.c
>   CC [M]  drivers/gpu/drm/i915/dvo_tfp410.o
>   CHECK   drivers/gpu/drm/i915/dvo_sil164.c
>   CC [M]  drivers/gpu/drm/i915/dvo_sil164.o
>   CHECK   drivers/gpu/drm/i915/dvo_ns2501.c
>   CC [M]  drivers/gpu/drm/i915/dvo_ns2501.o
>   CHECK   drivers/gpu/drm/i915/i915_gem_dmabuf.c
>   CC [M]  drivers/gpu/drm/i915/i915_gem_dmabuf.o
>   CHECK   drivers/gpu/drm/i915/i915_ioc32.c
>   CC [M]  drivers/gpu/drm/i915/i915_ioc32.o
>   CHECK   drivers/gpu/drm/i915/intel_acpi.c
>   CC [M]  drivers/gpu/drm/i915/intel_acpi.o
>   LD [M]  drivers/gpu/drm/i915/i915.o
>   Building modules, stage 2.
>   MODPOST 1 modules
>   CC      drivers/gpu/drm/i915/i915.mod.o
>   LD [M]  drivers/gpu/drm/i915/i915.ko
> 
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Queued for -next (3.9), thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
