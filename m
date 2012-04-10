Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2DJSLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:11:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55848 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2DJSLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:11:33 -0400
Message-ID: <4F8477D1.4080102@suse.cz>
Date: Tue, 10 Apr 2012 20:11:29 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz> <4F758400.3080907@suse.cz> <1333104359_155028@CP5-2952> <20120409101119.47e770b2@jbarnes-desktop> <4F83F3B5.8080704@suse.cz> <20120410092619.26a15165@jbarnes-desktop>
In-Reply-To: <20120410092619.26a15165@jbarnes-desktop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 06:26 PM, Jesse Barnes wrote:
> So port hotplug is always reporting that port C has a hotplug
> interrupt though...  If you write 0x3 back to it does the interrupt
> stop?

I'm not sure I got it right. This doesn't help:
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1416,6 +1416,17 @@ static irqreturn_t
i915_driver_irq_handler(DRM_IRQ_ARGS)
                iir = new_iir;
        }

+       if (ret == IRQ_NONE) {
+               u32 hp = I915_READ(PORT_HOTPLUG_STAT);
+               if (hp) {
+                       I915_WRITE(PORT_HOTPLUG_STAT, hp);
+                       I915_READ(PORT_HOTPLUG_STAT);
+               }
+
+               if (printk_ratelimit())
+                       printk(KERN_DEBUG "%s: %.8x\n", __func__, hp);
+
+       }

        return ret;
 }

thanks,
-- 
js
suse labs


