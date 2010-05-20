Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0ETB1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:27:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0ETB1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KZeNWwnXWZExeacO/tauz8uN/yZpSS95hHfUBcSxP/AePz2al20SjikMY4bfn1ZA8E
         GR48oyhhncqXBDdm+mlF0rkghAINWvAVgz2INM5MUCBrvQ630qolWxt0lg0tOci0oQ3N
         Vaj+SJBUXQ5cjTzoWX6OvNL3QflmqM7+eJ840=
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
In-Reply-To: <1274317983.2815.1.camel@maxim-laptop>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	 <20100519173449.6babbdfa@virtuousgeek.org>
	 <1274317983.2815.1.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 04:27:07 +0300
Message-ID: <1274318827.3386.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 04:13 +0300, Maxim Levitsky wrote: 
> On Wed, 2010-05-19 at 17:34 -0700, Jesse Barnes wrote: 
> > On Fri, 9 Apr 2010 15:10:50 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > This set of 3 patches makes it a little more likely we'll get panic
> > > output onto the screen even when X is running, assuming a KMS enabled
> > > stack anyway.
> > > 
> > > It gets me from a blank or very sparsely populated black screen at
> > > panic time, to one including the full backtrace and panic output at
> > > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > > session).
> > > 
> > > It doesn't cover every case; for instance I think it'll fail when X has
> > > disabled the display, but those cases need to be handled with separate
> > > patches anyway (need to add atomic DPMS paths for instance).
> > > 
> > > Anyway, please test these out and let me know if they work for you.
> > 
> > Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.
> > 
> Second that, just tested these patches, and these work perfectly.
> One more reason for me to dump nvidia driver for nouveau.


Unfortunately I spoke too soon.


After suspend to ram, system doesn't properly resume now.

My system is based on nvidia G86, I use latest nouveau drivers, and
suspend with compiz running.

I also patched kernel not to do vt switch on suspend/resume:

diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c
b/drivers/gpu/drm/nouveau/nouveau_state.c
index 062b7f6..b3ef08b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_state.c
+++ b/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -31,6 +31,7 @@
#include "drm_crtc_helper.h"
#include <linux/vgaarb.h>
#include <linux/vga_switcheroo.h>
+#include <linux/suspend.h>

#include "nouveau_drv.h"
#include "nouveau_drm.h"
@@ -771,6 +772,8 @@ int nouveau_load(struct drm_device *dev, unsigned
long flags)
                int ret = nouveau_card_init(dev);
                if (ret)
                        return ret;
+
+               pm_set_vt_switch(0);
        }

        return 0;



Best regards,
Maxim Levitsky

