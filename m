Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab1D2S65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:57 -0400
Received: from kroah.org ([198.145.64.141]:50392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab1D2S6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.233703857@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>
Subject: [48/55] drm: select FRAMEBUFFER_CONSOLE_PRIMARY if we have FRAMEBUFFER_CONSOLE
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit bf5192edcbc1f0a7f9c054649dbf1a0b3210d9b7 upstream.

Multi-gpu/switcheroo relies on this option to get the console on the
correct GPU at bootup, some distros enable it but it seems some get
it wrong.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -24,6 +24,7 @@ config DRM_KMS_HELPER
 	depends on DRM
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EXPERT
+	select FRAMEBUFFER_CONSOLE_DETECT_PRIMARY if FRAMEBUFFER_CONSOLE
 	help
 	  FB and CRTC helpers for KMS drivers.
 


