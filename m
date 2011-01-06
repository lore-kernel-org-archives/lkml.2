Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1AFAcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:32:00 -0500
Received: from kroah.org ([198.145.64.141]:36155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1AFAb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:57 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:10 2011
Message-Id: <20110106002310.551424619@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:24:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Baruch Siach <baruch@tkos.co.il>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [148/152] [media] mx2_camera: fix pixel clock polarity configuration
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 42cc37fe20cc680fb58fe12ae5ba718d683b8ca2 upstream.

When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, otherwise we get
the inverted behaviour.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/mx2_camera.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -791,8 +791,6 @@ static int mx2_camera_set_bus_param(stru
 
 	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
-	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
-		csicr1 |= CSICR1_INV_PCLK;
 	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
 	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)


