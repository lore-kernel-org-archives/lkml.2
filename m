Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1HDLK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:10:26 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:57125 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab1HDLKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:10:24 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 07:10:24 EDT
X-Yandex-Spam: 1
From: Dmitry Dmitriev <dimondmm@yandex.ru>
To: chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: PROBLEM: Possible problem in i915_dma_cleanup function in i915_dma.c module
MIME-Version: 1.0
Message-Id: <365371312455777@web44.yandex.ru>
Date: Thu, 04 Aug 2011 15:02:57 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This problem is found in 3.0 kernel.

In i915_dma_cleanup function(drivers/gpu/drm/i915/i915_dma.c module) I found following:
š135static int i915_dma_cleanup(struct drm_device * dev)
š136{
.......
š152 ššššššš/* Clear the HWS virtual address at teardown */
š153 šššššššif (I915_NEED_GFX_HWS(dev))
š154 ššššššššššššššši915_free_hws(dev);
.......
š157}

2102int i915_driver_unload(struct drm_device *dev)
2103{
........
2174 šššššššššššššššif (!I915_NEED_GFX_HWS(dev))
2175 ššššššššššššššššššššššši915_free_hws(dev);
........
2190}

I.e. in one case i915_free_hws function is called when (I915_NEED_GFX_HWS(dev)) condition is true(i915_dma_cleanup), but in other case it called when (!I915_NEED_GFX_HWS(dev)) condition is true(in i915_driver_unload function). This is intentional?

Corresponding init function is called only when (!I915_NEED_GFX_HWS(dev)) condition is true(in i915_driver_load function). Therefore I guess that if condition is wrong in i915_dma_cleanup function.

Thanks,
Dmitry
