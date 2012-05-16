Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab2EPHdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:33:12 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:40478
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759538Ab2EPHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:30 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access Macro to head file.
Date: Wed, 16 May 2012 15:20:26 +0800
Message-ID: <1337152826-9850-8-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   45 -------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index b2ca317..e6a0cba 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -33,51 +33,6 @@
 #define TWI_I2C_MODE_COMBINED		3
 #define TWI_I2C_MODE_REPEAT		4
 
-struct bfin_twi_iface {
-	int			irq;
-	spinlock_t		lock;
-	char			read_write;
-	u8			command;
-	u8			*transPtr;
-	int			readNum;
-	int			writeNum;
-	int			cur_mode;
-	int			manual_stop;
-	int			result;
-	struct i2c_adapter	adap;
-	struct completion	complete;
-	struct i2c_msg 		*pmsg;
-	int			msg_num;
-	int			cur_msg;
-	u16			saved_clkdiv;
-	u16			saved_control;
-	void __iomem		*regs_base;
-};
-
-
-#define DEFINE_TWI_REG(reg, off) \
-static inline u16 read_##reg(struct bfin_twi_iface *iface) \
-	{ return bfin_read16(iface->regs_base + (off)); } \
-static inline void write_##reg(struct bfin_twi_iface *iface, u16 v) \
-	{ bfin_write16(iface->regs_base + (off), v); }
-
-DEFINE_TWI_REG(CLKDIV, 0x00)
-DEFINE_TWI_REG(CONTROL, 0x04)
-DEFINE_TWI_REG(SLAVE_CTL, 0x08)
-DEFINE_TWI_REG(SLAVE_STAT, 0x0C)
-DEFINE_TWI_REG(SLAVE_ADDR, 0x10)
-DEFINE_TWI_REG(MASTER_CTL, 0x14)
-DEFINE_TWI_REG(MASTER_STAT, 0x18)
-DEFINE_TWI_REG(MASTER_ADDR, 0x1C)
-DEFINE_TWI_REG(INT_STAT, 0x20)
-DEFINE_TWI_REG(INT_MASK, 0x24)
-DEFINE_TWI_REG(FIFO_CTL, 0x28)
-DEFINE_TWI_REG(FIFO_STAT, 0x2C)
-DEFINE_TWI_REG(XMT_DATA8, 0x80)
-DEFINE_TWI_REG(XMT_DATA16, 0x84)
-DEFINE_TWI_REG(RCV_DATA8, 0x88)
-DEFINE_TWI_REG(RCV_DATA16, 0x8C)
-
 static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
 					unsigned short twi_int_status)
 {
-- 
1.7.0.4


