Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2HTEIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:08:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2HTEAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:00:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Bumiller <e0425955@student.tuwien.ac.at>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 09/46] drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate
Date: Sun, 19 Aug 2012 20:58:45 -0700
Message-Id: <20120820035833.564780628@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Bumiller <e0425955@student.tuwien.ac.at>

commit af5e7d84b0ec45b2b614b0d6e3657cbdceaa21f9 upstream.

Signed-off-by: Christoph Bumiller <e0425955@student.tuwien.ac.at>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvd0_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvd0_display.c
+++ b/drivers/gpu/drm/nouveau/nvd0_display.c
@@ -790,7 +790,7 @@ nvd0_crtc_cursor_move(struct drm_crtc *c
 	struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
 	int ch = EVO_CURS(nv_crtc->index);
 
-	evo_piow(crtc->dev, ch, 0x0084, (y << 16) | x);
+	evo_piow(crtc->dev, ch, 0x0084, (y << 16) | (x & 0xffff));
 	evo_piow(crtc->dev, ch, 0x0080, 0x00000000);
 	return 0;
 }


