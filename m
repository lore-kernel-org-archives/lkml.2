Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1CaANN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:13:13 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:33557 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1CaANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:13:11 -0400
Subject: [PATCH] efifb: support AMD Radeon HD 6490
From: Davidlohr Bueso <dave@gnu.org>
To: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, zeus@gnu.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 21:12:22 -0300
Message-ID: <1301530342.2140.2.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the framebuffer for the AMD Radeon 6490 found in the new MacBook Pro 8,2 generation.
The framebuffer's base is located at 0x90010000, the method for obtaining it was found in the same way mentioned in https://patchwork.kernel.org/patch/91704/

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Jonathan Gonzalez <zeus@gnu.org>
---
 drivers/video/efifb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 70477c2..a9645b8 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -64,6 +64,7 @@ enum {
 	M_MBP_6_1,	/* MacBook Pro, 6,1th gen */
 	M_MBP_6_2,	/* MacBook Pro, 6,2th gen */
 	M_MBP_7_1,	/* MacBook Pro, 7,1th gen */
+	M_MBP_8_2,	/* MacBook Pro, 8,2nd gen */
 	M_UNKNOWN	/* placeholder */
 };
 
@@ -100,6 +101,7 @@ static struct efifb_dmi_info {
 	[M_MBP_6_1] = { "mbp61", 0x90030000, 2048 * 4, 1920, 1200 },
 	[M_MBP_6_2] = { "mbp62", 0x90030000, 2048 * 4, 1680, 1050 },
 	[M_MBP_7_1] = { "mbp71", 0xc0010000, 2048 * 4, 1280, 800 },
+	[M_MBP_8_2] = { "mbp82", 0x90010000, 1472 * 4, 1440, 900 },
 	[M_UNKNOWN] = { NULL, 0, 0, 0, 0 }
 };
 
@@ -151,6 +153,7 @@ static const struct dmi_system_id dmi_system_table[] __initconst = {
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,1", M_MBP_6_1),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,2", M_MBP_6_2),
 	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro7,1", M_MBP_7_1),
+	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro8,2", M_MBP_8_2),
 	{},
 };
 
-- 
1.7.1



