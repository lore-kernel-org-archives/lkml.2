Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3AFU63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:58:29 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:46234 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3AFU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:58:28 -0500
From: Emil Goode <emilgoode@gmail.com>
To: patricechotard@free.fr, martin.blumenstingl@googlemail.com,
        gregkh@linuxfoundation.org, crope@iki.fi
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [media] ngene: Use newly created function
Date: Sun,  6 Jan 2013 21:59:12 +0100
Message-Id: <1357505952-14439-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function demod_attach_drxd was split into two by commit 36a495a3.
This resulted in a new function tuner_attach_dtt7520x that is not used.
We should register tuner_attach_dtt7520x as a callback in the ngene_info
struct in the same way as done with the other part of the split function.

Sparse warning:

drivers/media/pci/ngene/ngene-cards.c:333:12: warning:
        ‘tuner_attach_dtt7520x’ defined but not used [-Wunused-function]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
This patch is a guess at what was intended. I'm not familiar with this code
and I don't have the hardware to test it.

 drivers/media/pci/ngene/ngene-cards.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index c99f779..60605c8 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -732,6 +732,7 @@ static struct ngene_info ngene_info_terratec = {
 	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
 	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
+	.tuner_attach   = {tuner_attach_dtt7520x, tuner_attach_dtt7520x},
 	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
 	.i2c_access     = 1,
 };
-- 
1.7.10.4

