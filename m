Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2ESWXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:23:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36870 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab2ESWXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:23:17 -0400
Message-ID: <4FB81D52.5050106@suse.cz>
Date: Sun, 20 May 2012 00:23:14 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120514 Thunderbird/14.0a2
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: [-next] DRM_CIRRUS_QEMU breaks build
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when that option is selected to be Y, I'm getting linking errors like:
    (.text+0xefd8d): undefined reference to `ttm_tt_init'
    drivers/built-in.o: In function `cirrus_mm_init':
and many others, like undefined sys_fillrect.

You perhaps have a patch on your queue already and I need not to turn
this into a patch, right :):

--- a/drivers/gpu/drm/cirrus/Kconfig
+++ b/drivers/gpu/drm/cirrus/Kconfig
@@ -1,10 +1,11 @@
 config DRM_CIRRUS_QEMU
        tristate "Cirrus driver for QEMU emulated device"
        depends on DRM && PCI && EXPERIMENTAL
-       select FB_CFB_FILLRECT
-       select FB_CFB_COPYAREA
-       select FB_CFB_IMAGEBLIT
+       select FB_SYS_FILLRECT
+       select FB_SYS_COPYAREA
+       select FB_SYS_IMAGEBLIT
        select DRM_KMS_HELPER
+       select DRM_TTM
        help
         This is a KMS driver for emulated cirrus device in qemu.
         It is *NOT* intended for real cirrus devices. This requires

regards,
-- 
js
suse labs

