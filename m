Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2GZRFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:05:45 -0400
Received: from mail.tpi.com ([70.99.223.143]:1591 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab2GZRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:05:44 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Subject: [PATCH] cx18: Declare MODULE_FIRMWARE usage
Date: Thu, 26 Jul 2012 11:05:58 -0600
Message-Id: <1343322358-128310-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ivtv-devel@ivtvdriver.org
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/cx18/cx18-driver.c   |    1 +
 drivers/media/video/cx18/cx18-firmware.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 7e5ffd6..c67733d 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -1357,3 +1357,4 @@ static void __exit module_cleanup(void)
 
 module_init(module_start);
 module_exit(module_cleanup);
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
index b85c292..a1c1cec 100644
--- a/drivers/media/video/cx18/cx18-firmware.c
+++ b/drivers/media/video/cx18/cx18-firmware.c
@@ -376,6 +376,9 @@ void cx18_init_memory(struct cx18 *cx)
 	cx18_write_reg(cx, 0x00000101, CX18_WMB_CLIENT14);  /* AVO */
 }
 
+#define CX18_CPU_FIRMWARE "v4l-cx23418-cpu.fw"
+#define CX18_APU_FIRMWARE "v4l-cx23418-apu.fw"
+
 int cx18_firmware_init(struct cx18 *cx)
 {
 	u32 fw_entry_addr;
@@ -400,7 +403,7 @@ int cx18_firmware_init(struct cx18 *cx)
 	cx18_sw1_irq_enable(cx, IRQ_CPU_TO_EPU | IRQ_APU_TO_EPU);
 	cx18_sw2_irq_enable(cx, IRQ_CPU_TO_EPU_ACK | IRQ_APU_TO_EPU_ACK);
 
-	sz = load_cpu_fw_direct("v4l-cx23418-cpu.fw", cx->enc_mem, cx);
+	sz = load_cpu_fw_direct(CX18_CPU_FIRMWARE, cx->enc_mem, cx);
 	if (sz <= 0)
 		return sz;
 
@@ -408,7 +411,7 @@ int cx18_firmware_init(struct cx18 *cx)
 	cx18_init_scb(cx);
 
 	fw_entry_addr = 0;
-	sz = load_apu_fw_direct("v4l-cx23418-apu.fw", cx->enc_mem, cx,
+	sz = load_apu_fw_direct(CX18_APU_FIRMWARE, cx->enc_mem, cx,
 				&fw_entry_addr);
 	if (sz <= 0)
 		return sz;
@@ -451,3 +454,6 @@ int cx18_firmware_init(struct cx18 *cx)
 	cx18_write_reg_expect(cx, 0x14001400, 0xc78110, 0x00001400, 0x14001400);
 	return 0;
 }
+
+MODULE_FIRMWARE(CX18_CPU_FIRMWARE);
+MODULE_FIRMWARE(CX18_APU_FIRMWARE);
-- 
1.7.9.5

