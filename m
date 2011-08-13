Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1HMMnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 08:43:08 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:42534 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1HMMnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 08:43:05 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: gregkh@suse.de
Cc: mchehab@redhat.com, palash.bandyopadhyay@conexant.com,
        ruslan@rpisarev.org.ua, Revent82@gmail.com, joe@perches.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v2] Staging: cx25821: fix coding style issues
Date: Sat, 13 Aug 2011 20:42:50 +0800
Message-Id: <1313239370-7882-1-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix too long lines in cx25821-audio.h
Fix wrong brace placement in cx25821-cards.c, cx25821-core.c,
and cx25821-i2c.c
Use DEFINE_PCI_DEVICE_TABLE for cx25821_pci_tbl.
Move EXPORT_SYMBOL(cx25821_set_gpiopin_direction) to the right place.
Delete file cx25821-gpio.h since it is not used.
Get rid of typedef in cx25821.h.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-audio.h |    6 ++++--
 drivers/staging/cx25821/cx25821-cards.c |    2 +-
 drivers/staging/cx25821/cx25821-core.c  |    7 +++----
 drivers/staging/cx25821/cx25821-gpio.c  |    1 +
 drivers/staging/cx25821/cx25821-gpio.h  |    2 --
 drivers/staging/cx25821/cx25821-i2c.c   |    6 +++---
 drivers/staging/cx25821/cx25821.h       |    8 +++++---
 7 files changed, 17 insertions(+), 15 deletions(-)
 delete mode 100644 drivers/staging/cx25821/cx25821-gpio.h

diff --git a/drivers/staging/cx25821/cx25821-audio.h b/drivers/staging/cx25821/cx25821-audio.h
index 2771725..a2098fb 100644
--- a/drivers/staging/cx25821/cx25821-audio.h
+++ b/drivers/staging/cx25821/cx25821-audio.h
@@ -36,13 +36,15 @@
  */
 #ifndef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
+	RISC_WRITECR_INSTRUCTION_SIZE*4)
 #endif
 
 /* MAE 12 July 2005 Try to use NOOP RISC instruction instead */
 #ifdef USE_RISC_NOOP
 #define MAX_BUFFER_PROGRAM_SIZE     \
-	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + RISC_NOOP_INSTRUCTION_SIZE*4)
+	(2*LINES_PER_BUFFER*RISC_WRITE_INSTRUCTION_SIZE + \
+	RISC_NOOP_INSTRUCTION_SIZE*4)
 #endif
 
 /* Sizes of various instructions in bytes.  Used when adding instructions. */
diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
index 94e8d68..9f7febd 100644
--- a/drivers/staging/cx25821/cx25821-cards.c
+++ b/drivers/staging/cx25821/cx25821-cards.c
@@ -57,7 +57,7 @@ struct cx25821_subid cx25821_subids[] = {
 	 .subvendor = 0x14f1,
 	 .subdevice = 0x0920,
 	 .card = CX25821_BOARD,
-	 },
+	},
 };
 
 void cx25821_card_setup(struct cx25821_dev *dev)
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 523ac5e..f06c671 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1473,17 +1473,17 @@ static void __devexit cx25821_finidev(struct pci_dev *pci_dev)
 	kfree(dev);
 }
 
-static struct pci_device_id cx25821_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
 	{
 	 /* CX25821 Athena */
 	 .vendor = 0x14f1,
 	 .device = 0x8210,
 	 .subvendor = 0x14f1,
 	 .subdevice = 0x0920,
-	 },
+	},
 	{
 	 /* --- end of list --- */
-	 }
+	}
 };
 
 MODULE_DEVICE_TABLE(pci, cx25821_pci_tbl);
@@ -1512,7 +1512,6 @@ static void __exit cx25821_fini(void)
 	pci_unregister_driver(&cx25821_pci_driver);
 }
 
-EXPORT_SYMBOL(cx25821_set_gpiopin_direction);
 
 module_init(cx25821_init);
 module_exit(cx25821_fini);
diff --git a/drivers/staging/cx25821/cx25821-gpio.c b/drivers/staging/cx25821/cx25821-gpio.c
index 2f154b3..29e43b0 100644
--- a/drivers/staging/cx25821/cx25821-gpio.c
+++ b/drivers/staging/cx25821/cx25821-gpio.c
@@ -50,6 +50,7 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 
 	cx_write(gpio_oe_reg, value);
 }
+EXPORT_SYMBOL(cx25821_set_gpiopin_direction);
 
 static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 					   int pin_number, int pin_logic_value)
diff --git a/drivers/staging/cx25821/cx25821-gpio.h b/drivers/staging/cx25821/cx25821-gpio.h
deleted file mode 100644
index ca07644..0000000
--- a/drivers/staging/cx25821/cx25821-gpio.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-void cx25821_gpio_init(struct athena_dev *dev);
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 130dfeb..ea5a878 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -374,12 +374,12 @@ int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value)
 		 .flags = 0,
 		 .len = 2,
 		 .buf = addr,
-		 }, {
+		}, {
 		     .addr = client->addr,
 		     .flags = I2C_M_RD,
 		     .len = 4,
 		     .buf = buf,
-		     }
+		}
 	};
 
 	addr[0] = (reg_addr >> 8);
@@ -407,7 +407,7 @@ int cx25821_i2c_write(struct cx25821_i2c *bus, u16 reg_addr, int value)
 		 .flags = 0,
 		 .len = 6,
 		 .buf = buf,
-		 }
+		}
 	};
 
 	buf[0] = reg_addr >> 8;
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 6230243..a282592 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -179,15 +179,17 @@ struct cx25821_input {
 	u32 gpio0, gpio1, gpio2, gpio3;
 };
 
-typedef enum {
+enum port {
 	CX25821_UNDEFINED = 0,
 	CX25821_RAW,
 	CX25821_264
-} port_t;
+};
 
 struct cx25821_board {
 	char *name;
-	port_t porta, portb, portc;
+	enum port porta;
+	enum port portb;
+	enum port portc;
 	unsigned int tuner_type;
 	unsigned int radio_type;
 	unsigned char tuner_addr;
-- 
1.7.0.4

