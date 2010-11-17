Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0KQKhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:37:54 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:46393 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab0KQKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:37:53 -0500
Date: Wed, 17 Nov 2010 11:35:25 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media: nuvoton: fix chip id probe
Message-ID: <20101117113525.1ded029c@absol.kitzblitz>
In-Reply-To: <4CE33527.8090800@infradead.org>
References: <20101116211953.238012db@absol.kitzblitz>
	<20101116215408.GA17140@redhat.com>
	<4CE33527.8090800@infradead.org>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we have a matching chip id high and one or the other
of the chip id low values.
Print the values if the probe fails.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Like this?
Supersedes patch "drivers/media: nuvoton: always true expression".

 drivers/media/IR/nuvoton-cir.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index 301be53..92d32c8 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -249,9 +249,12 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
 	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
 	nvt_dbg("%s: chip id: 0x%02x 0x%02x", chip_id, chip_major, chip_minor);
 
-	if (chip_major != CHIP_ID_HIGH &&
-	    (chip_minor != CHIP_ID_LOW || chip_minor != CHIP_ID_LOW2))
+	if (chip_major != CHIP_ID_HIGH ||
+	    (chip_minor != CHIP_ID_LOW && chip_minor != CHIP_ID_LOW2)) {
+		nvt_pr(KERN_ERR, "%s: chip id mismatch: 0x%02x 0x%02x",
+		       chip_id, chip_major, chip_minor);
 		ret = -ENODEV;
+	}
 
 	nvt_efm_disable(nvt);
 
-- 
1.7.2.2
