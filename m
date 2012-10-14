Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2JNOkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:40:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63843 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2JNOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:40:10 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <507AC9DC.4030701@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com>
	<507A91EA.2030205@cfl.rr.com>
	<CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com>
	<507AC9DC.4030701@cfl.rr.com>
Date: Sun, 14 Oct 2012 16:40:08 +0200
X-Google-Sender-Auth: VTJ7gm20AG_SQQGXm8eNFdUKBK4
Message-ID: <CAKMK7uERj4+QtxMzzHsbxbqvUYNGWxmieZeebS3+CjAbj6Kq1g@mail.gmail.com>
Subject: Re: [Intel-gfx] Intel graphics drm issue?
From: Daniel Vetter <daniel@ffwll.ch>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 4:19 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> OK. Applied to 3.6.2. The dmesg is attached. The message did not show up.
> I'll be here most of the day.

Ok, that at least confirms my suspicion (and yeah, I've mis-remembered
when I've merged the agp removal for gen6+, it's already all done in
3.6). But I have no idea how that could fail this way. New little
debug patch:

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index a24ffbe..7ec35c5 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -848,6 +848,11 @@ i915_pci_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
                return -ENODEV;
        }

+       printk("force-disabling agp on gen %i, is_ivybridge %i\n",
+              intel_info->gen, intel_info->is_ivybridge);
+
+       driver.driver_features &=
+               ~(DRIVER_USE_AGP | DRIVER_REQUIRE_AGP);
        return drm_get_pci_dev(pdev, ent, &driver);
 }

Yours, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
