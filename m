Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0LLXqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0LLXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: moinejf@free.fr, moinejf@free.fr, moinejf@free.fr, mchehab@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [101/223] gspca - sonixj: Fix a regression of sensors hv7131r and mi0360
Message-Id: <20101212234641.89455B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>

commit 0303a90a744662e934877a5d637a43197229274b upstream.

The bug was introduced by commit 23a98274cc348880ecb6803307c254448084953a
applying values of sensor sp80708 to sensors hv7131r and mi0360.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/gspca/sonixj.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/media/video/gspca/sonixj.c
===================================================================
--- linux.orig/drivers/media/video/gspca/sonixj.c
+++ linux/drivers/media/video/gspca/sonixj.c
@@ -2488,8 +2488,7 @@ static int sd_start(struct gspca_dev *gs
 		reg1 = 0x44;
 		reg17 = 0xa2;
 		break;
-	default:
-/*	case SENSOR_SP80708: */
+	case SENSOR_SP80708:
 		init = sp80708_sensor_param1;
 		if (mode) {
 /*??			reg1 = 0x04;	 * 320 clk 48Mhz */
