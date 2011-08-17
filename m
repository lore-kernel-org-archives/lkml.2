Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1HQUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:37:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45135 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1HQUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:37:17 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Marc Dietrich <marvin24@gmx.de>,
        Jiri Kosina <jkosina@suse.cz>, Vitaliy Ivanov <vitalivanov@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH] Staging: nvec: Fixed various style issues.
Date: Wed, 17 Aug 2011 16:36:32 -0400
Message-Id: <1313613397-18126-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed trailing spaces, brace/parenthesis issues and other coding style
problems, along with commented out code.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/nvec/Kconfig         |    2 +-
 drivers/staging/nvec/nvec-keytable.h |   58 ++++----
 drivers/staging/nvec/nvec.c          |   84 ++++------
 drivers/staging/nvec/nvec.h          |    8 +-
 drivers/staging/nvec/nvec_kbd.c      |   22 ++--
 drivers/staging/nvec/nvec_power.c    |  288 ++++++++++++++++------------------
 drivers/staging/nvec/nvec_ps2.c      |   50 +++---
 7 files changed, 241 insertions(+), 271 deletions(-)

diff --git a/drivers/staging/nvec/Kconfig b/drivers/staging/nvec/Kconfig
index 987ad48..9a7e4e4 100644
--- a/drivers/staging/nvec/Kconfig
+++ b/drivers/staging/nvec/Kconfig
@@ -9,7 +9,7 @@ config KEYBOARD_NVEC
 	bool "Keyboard on nVidia compliant EC"
 	depends on MFD_NVEC
 	help
-	  Say Y here to enable support for a keyboard connected to 
+	  Say Y here to enable support for a keyboard connected to
 	  a nVidia compliant embedded controller.
 
 config SERIO_NVEC_PS2
diff --git a/drivers/staging/nvec/nvec-keytable.h b/drivers/staging/nvec/nvec-keytable.h
index 6a1c4f7..acd3929 100644
--- a/drivers/staging/nvec/nvec-keytable.h
+++ b/drivers/staging/nvec/nvec-keytable.h
@@ -111,42 +111,42 @@ static unsigned short code_tab_102us[] = {
 	KEY_102ND,		//VK_OEM_102   henry+ 0x2B (43) BACKSLASH have been used,change to use 0X56 (86)
 	KEY_F11,		//VK_F11
 	KEY_F12,		//VK_F12
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, // 60 
 	0,
 	0,
-	KEY_SEARCH, // add search key map 
-	0,		
 	0,
 	0,
-	0,	
-	0,		
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, 
-	0, // 70 
+	0,
+	0,
+	0,
+	0, // 60
+	0,
+	0,
+	KEY_SEARCH, // add search key map
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0, // 70
 	0,
 	0,
 	KEY_KP5,  //73 for JP keyboard '\' key, report 0x4c
-	0,		
 	0,
 	0,
-	0,	
-	0,		
-	0, 
-	0, 
-    0, 
-	0, 
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
 	KEY_KP9, //7d  for JP keyboard '|' key, report 0x49
 };
 
@@ -246,7 +246,7 @@ static unsigned short extcode_tab_us102[] = {
 	0,		//VK_RWIN
 	KEY_ESC,	//VK_APPS
 	KEY_KPMINUS, //for power button workaround
-	0, 
+	0,
 	0,
 	0,
 	0,
@@ -263,4 +263,4 @@ static unsigned short extcode_tab_us102[] = {
 	0,		//VK_LAUNCH_MEDIA_SELECT
 };
 
-static unsigned short* code_tabs[] = {code_tab_102us, extcode_tab_us102 };
+static unsigned short *code_tabs[] = {code_tab_102us, extcode_tab_us102 };
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 72258e8..b822cda 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -24,9 +24,9 @@
 #include <linux/platform_device.h>
 #include "nvec.h"
 
-static unsigned char EC_DISABLE_EVENT_REPORTING[] =	{'\x04','\x00','\x00'};
-static unsigned char EC_ENABLE_EVENT_REPORTING[] =	{'\x04','\x00','\x01'};
-static unsigned char EC_GET_FIRMWARE_VERSION[] =	{'\x07','\x15'};
+static unsigned char EC_DISABLE_EVENT_REPORTING[] =   {'\x04', '\x00', '\x00'};
+static unsigned char EC_ENABLE_EVENT_REPORTING[] =    {'\x04', '\x00', '\x01'};
+static unsigned char EC_GET_FIRMWARE_VERSION[] =      {'\x07', '\x15'};
 
 static struct nvec_chip *nvec_power_handle;
 
@@ -43,7 +43,7 @@ static int nvec_status_notifier(struct notifier_block *nb, unsigned long event_t
 	unsigned char *msg = (unsigned char *)data;
 	int i;
 
-	if(event_type != NVEC_CNTL)
+	if (event_type != NVEC_CNTL)
 		return NOTIFY_DONE;
 
 	printk("unhandled msg type %ld, payload: ", event_type);
@@ -75,25 +75,23 @@ static void nvec_request_master(struct work_struct *work)
 {
 	struct nvec_chip *nvec = container_of(work, struct nvec_chip, tx_work);
 
-	if(!list_empty(&nvec->tx_data)) {
+	if (!list_empty(&nvec->tx_data))
 		gpio_set_value(nvec->gpio, 0);
-	}
 }
 
 static int parse_msg(struct nvec_chip *nvec, struct nvec_msg *msg)
 {
 	int i;
 
-	if((msg->data[0] & 1<<7) == 0 && msg->data[3]) {
+	if ((msg->data[0] & 1<<7) == 0 && msg->data[3]) {
 		dev_err(nvec->dev, "ec responded %02x %02x %02x %02x\n", msg->data[0],
 			msg->data[1], msg->data[2], msg->data[3]);
 		return -EINVAL;
 	}
 
-	if ((msg->data[0] >> 7 ) == 1 && (msg->data[0] & 0x0f) == 5)
-	{
+	if ((msg->data[0] >> 7) == 1 && (msg->data[0] & 0x0f) == 5) {
 		dev_warn(nvec->dev, "ec system event ");
-		for (i=0; i < msg->data[1]; i++)
+		for (i = 0; i < msg->data[1]; i++)
 			dev_warn(nvec->dev, "%02x ", msg->data[2+i]);
 		dev_warn(nvec->dev, "\n");
 	}
@@ -125,20 +123,18 @@ static void nvec_dispatch(struct work_struct *work)
 	struct nvec_chip *nvec = container_of(work, struct nvec_chip, rx_work);
 	struct nvec_msg *msg;
 
-	while(!list_empty(&nvec->rx_data))
-	{
+	while (!list_empty(&nvec->rx_data)) {
 		msg = list_first_entry(&nvec->rx_data, struct nvec_msg, node);
 		list_del_init(&msg->node);
 
-		if(nvec->sync_write_pending == (msg->data[2] << 8) + msg->data[0])
-		{
+		if (nvec->sync_write_pending == (msg->data[2] << 8) + msg->data[0]) {
 			dev_dbg(nvec->dev, "sync write completed!\n");
 			nvec->sync_write_pending = 0;
 			nvec->last_sync_msg = msg;
 			complete(&nvec->sync_write);
 		} else {
 			parse_msg(nvec, msg);
-			if((!msg) || (!msg->data))
+			if ((!msg) || (!msg->data))
 				dev_warn(nvec->dev, "attempt access zero pointer");
 			else {
 				kfree(msg->data);
@@ -159,20 +155,17 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
 
 	status = readl(i2c_regs + I2C_SL_STATUS);
 
-	if(!(status & I2C_SL_IRQ))
-	{
+	if (!(status & I2C_SL_IRQ)) {
 		dev_warn(nvec->dev, "nvec Spurious IRQ\n");
-		//Yup, handled. ahum.
+		/* Yup, handled. ahum. */
 		goto handled;
 	}
-	if(status & END_TRANS && !(status & RCVD))
-	{
-		//Reenable IRQ only when even has been sent
+	if (status & END_TRANS && !(status & RCVD)) {
+		/* Reenable IRQ only when even has been sent */
 		//printk("Write sequence ended !\n");
-                //parse_msg(nvec);
+		//parse_msg(nvec);
 		nvec->state = NVEC_WAIT;
-		if(nvec->rx->size > 1)
-		{
+		if (nvec->rx->size > 1) {
 			list_add_tail(&nvec->rx->node, &nvec->rx_data);
 			schedule_work(&nvec->rx_work);
 		} else {
@@ -180,15 +173,13 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
 			kfree(nvec->rx);
 		}
 		return IRQ_HANDLED;
-	} else if(status & RNW)
-	{
+	} else if (status & RNW) {
 		// Work around for AP20 New Slave Hw Bug. Give 1us extra.
 		// nvec/smbus/nvec_i2c_transport.c in NV`s crap for reference
-		if(status & RCVD)
+		if (status & RCVD)
 			udelay(3);
 
-		if(status & RCVD)
-		{
+		if (status & RCVD) {
 			nvec->state = NVEC_WRITE;
 			//Master wants something from us. New communication
 //			dev_dbg(nvec->dev, "New read comm!\n");
@@ -197,15 +188,14 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
 //			dev_dbg(nvec->dev, "Read comm cont !\n");
 		}
 		//if(msg_pos<msg_size) {
-		if(list_empty(&nvec->tx_data))
-		{
+		if (list_empty(&nvec->tx_data)) {
 			dev_err(nvec->dev, "nvec empty tx - sending no-op\n");
 			to_send = 0x8a;
 			nvec_write_async(nvec, "\x07\x02", 2);
 //			to_send = 0x01;
 		} else {
 			msg = list_first_entry(&nvec->tx_data, struct nvec_msg, node);
-			if(msg->pos < msg->size) {
+			if (msg->pos < msg->size) {
 				to_send = msg->data[msg->pos];
 				msg->pos++;
 			} else {
@@ -213,8 +203,7 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
 				to_send = 0x01;
 			}
 
-			if(msg->pos >= msg->size)
-			{
+			if (msg->pos >= msg->size) {
 				list_del_init(&msg->node);
 				kfree(msg->data);
 				kfree(msg);
@@ -232,13 +221,12 @@ static irqreturn_t i2c_interrupt(int irq, void *dev)
 	} else {
 		received = readl(i2c_regs + I2C_SL_RCVD);
 		//Workaround?
-		if(status & RCVD) {
+		if (status & RCVD) {
 			writel(0, i2c_regs + I2C_SL_RCVD);
 			goto handled;
 		}
 
-		if (nvec->state == NVEC_WAIT)
-		{
+		if (nvec->state == NVEC_WAIT) {
 			nvec->state = NVEC_READ;
 			msg = kzalloc(sizeof(struct nvec_msg), GFP_NOWAIT);
 			msg->data = kzalloc(32, GFP_NOWAIT);
@@ -307,7 +295,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	unsigned char *i2c_regs;
 
 	nvec = kzalloc(sizeof(struct nvec_chip), GFP_KERNEL);
-	if(nvec == NULL) {
+	if (nvec == NULL) {
 		dev_err(&pdev->dev, "failed to reserve memory\n");
 		return -ENOMEM;
 	}
@@ -324,7 +312,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 		clk_enable(i2c_clk);
 */
 	i2c_regs = ioremap(pdata->base, pdata->size);
-	if(!i2c_regs) {
+	if (!i2c_regs) {
 		dev_err(nvec->dev, "failed to ioremap registers\n");
 		goto failed;
 	}
@@ -332,7 +320,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	nvec->i2c_regs = i2c_regs;
 
 	i2c_clk = clk_get_sys(pdata->clock, NULL);
-	if(IS_ERR_OR_NULL(i2c_clk)) {
+	if (IS_ERR_OR_NULL(i2c_clk)) {
 		dev_err(nvec->dev, "failed to get clock tegra-i2c.2\n");
 		goto failed;
 	}
@@ -340,7 +328,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	tegra_init_i2c_slave(pdata, i2c_regs, i2c_clk);
 
 	err = request_irq(nvec->irq, i2c_interrupt, IRQF_DISABLED, "nvec", nvec);
-	if(err) {
+	if (err) {
 		dev_err(nvec->dev, "couldn't request irq");
 		goto failed;
 	}
@@ -350,7 +338,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 
 	/* Set the gpio to low when we've got something to say */
 	err = gpio_request(nvec->gpio, "nvec gpio");
-	if(err < 0)
+	if (err < 0)
 		dev_err(nvec->dev, "couldn't request gpio\n");
 
 	tegra_gpio_enable(nvec->gpio);
@@ -375,10 +363,9 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	nvec_ps2(nvec);
 #endif
 
-        /* setup subdevs */
-	for (i = 0; i < pdata->num_subdevs; i++) {
+	/* setup subdevs */
+	for (i = 0; i < pdata->num_subdevs; i++)
 		ret = nvec_add_subdev(nvec, &pdata->subdevs[i]);
-	}
 
 	nvec->nvec_status_notifier.notifier_call = nvec_status_notifier;
 	nvec_register_notifier(nvec, &nvec->nvec_status_notifier, 0);
@@ -431,8 +418,8 @@ static int tegra_nvec_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int tegra_nvec_resume(struct platform_device *pdev) {
-
+static int tegra_nvec_resume(struct platform_device *pdev)
+{
 	struct nvec_chip *nvec = platform_get_drvdata(pdev);
 
 	dev_dbg(nvec->dev, "resuming\n");
@@ -446,8 +433,7 @@ static int tegra_nvec_resume(struct platform_device *pdev) {
 #define tegra_nvec_resume NULL
 #endif
 
-static struct platform_driver nvec_device_driver =
-{
+static struct platform_driver nvec_device_driver = {
 	.probe = tegra_nvec_probe,
 	.remove = __devexit_p(tegra_nvec_remove),
 	.suspend = tegra_nvec_suspend,
diff --git a/drivers/staging/nvec/nvec.h b/drivers/staging/nvec/nvec.h
index a2d82dc..d1f083b 100644
--- a/drivers/staging/nvec/nvec.h
+++ b/drivers/staging/nvec/nvec.h
@@ -16,7 +16,7 @@ typedef enum {
 } how_care;
 
 typedef enum {
-	NVEC_SYS=1,
+	NVEC_SYS = 1,
 	NVEC_BAT,
 	NVEC_KBD = 5,
 	NVEC_PS2,
@@ -26,9 +26,9 @@ typedef enum {
 } nvec_event;
 
 typedef enum {
-       NVEC_WAIT,
-       NVEC_READ,
-       NVEC_WRITE
+	NVEC_WAIT,
+	NVEC_READ,
+	NVEC_WRITE
 } nvec_state;
 
 struct nvec_msg {
diff --git a/drivers/staging/nvec/nvec_kbd.c b/drivers/staging/nvec/nvec_kbd.c
index 9a98507..04bd285 100644
--- a/drivers/staging/nvec/nvec_kbd.c
+++ b/drivers/staging/nvec/nvec_kbd.c
@@ -4,7 +4,7 @@
 #include "nvec-keytable.h"
 #include "nvec.h"
 
-#define ACK_KBD_EVENT {'\x05','\xed','\x01'}
+#define ACK_KBD_EVENT {'\x05', '\xed', '\x01'}
 
 static unsigned char keycodes[ARRAY_SIZE(code_tab_102us)
 			+ ARRAY_SIZE(extcode_tab_us102)];
@@ -27,10 +27,10 @@ static int nvec_keys_notifier(struct notifier_block *nb,
 		nvec_size _size = (msg[0] & (3 << 5)) >> 5;
 
 /* power on/off button */
-		if(_size == NVEC_VAR_SIZE)
+		if (_size == NVEC_VAR_SIZE)
 			return NOTIFY_STOP;
 
-		if(_size == NVEC_3BYTES)
+		if (_size == NVEC_3BYTES)
 			msg++;
 
 		code = msg[1] & 0x7f;
@@ -51,13 +51,13 @@ static int nvec_kbd_event(struct input_dev *dev, unsigned int type,
 	unsigned char buf[] = ACK_KBD_EVENT;
 	struct nvec_chip *nvec = keys_dev.nvec;
 
-	if(type==EV_REP)
+	if (type == EV_REP)
 		return 0;
 
-	if(type!=EV_LED)
+	if (type != EV_LED)
 		return -1;
 
-	if(code!=LED_CAPSL)
+	if (code != LED_CAPSL)
 		return -1;
 
 	buf[2] = !!value;
@@ -73,11 +73,11 @@ int __init nvec_kbd_init(struct nvec_chip *nvec)
 
 	j = 0;
 
-	for(i = 0; i < ARRAY_SIZE(code_tab_102us); ++i)
+	for (i = 0; i < ARRAY_SIZE(code_tab_102us); ++i)
 		keycodes[j++] = code_tab_102us[i];
 
-	for(i = 0; i < ARRAY_SIZE(extcode_tab_us102); ++i)
-		keycodes[j++]=extcode_tab_us102[i];
+	for (i = 0; i < ARRAY_SIZE(extcode_tab_us102); ++i)
+		keycodes[j++] = extcode_tab_us102[i];
 
 	idev = input_allocate_device();
 	idev->name = "Tegra nvec keyboard";
@@ -89,12 +89,12 @@ int __init nvec_kbd_init(struct nvec_chip *nvec)
 	idev->keycodesize = sizeof(unsigned char);
 	idev->keycodemax = ARRAY_SIZE(keycodes);
 
-	for( i = 0; i < ARRAY_SIZE(keycodes); ++i)
+	for (i = 0; i < ARRAY_SIZE(keycodes); ++i)
 		set_bit(keycodes[i], idev->keybit);
 
 	clear_bit(0, idev->keybit);
 	err = input_register_device(idev);
-	if(err)
+	if (err)
 		goto fail;
 
 	keys_dev.input = idev;
diff --git a/drivers/staging/nvec/nvec_power.c b/drivers/staging/nvec/nvec_power.c
index df164ad..d82dd97 100644
--- a/drivers/staging/nvec/nvec_power.c
+++ b/drivers/staging/nvec/nvec_power.c
@@ -7,8 +7,7 @@
 #include <linux/delay.h>
 #include "nvec.h"
 
-struct nvec_power
-{
+struct nvec_power {
 	struct notifier_block notifier;
 	struct delayed_work poller;
 	struct nvec_chip *nvec;
@@ -77,10 +76,8 @@ static int nvec_power_notifier(struct notifier_block *nb,
 	if (event_type != NVEC_SYS)
 		return NOTIFY_DONE;
 
-	if(res->sub_type == 0)
-	{
-		if (power->on != res->plu)
-		{
+	if (res->sub_type == 0) {
+		if (power->on != res->plu) {
 			power->on = res->plu;
 			power_supply_changed(&nvec_psy);
 		}
@@ -89,8 +86,7 @@ static int nvec_power_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static const int bat_init[] =
-{
+static const int bat_init[] = {
 	LAST_FULL_CHARGE_CAPACITY, DESIGN_CAPACITY, CRITICAL_CAPACITY,
 	MANUFACTURER, MODEL, TYPE,
 };
@@ -100,8 +96,7 @@ static void get_bat_mfg_data(struct nvec_power *power)
 	int i;
 	char buf[] = { '\x02', '\x00' };
 
-	for (i = 0; i < ARRAY_SIZE(bat_init); i++)
-	{
+	for (i = 0; i < ARRAY_SIZE(bat_init); i++) {
 		buf[1] = bat_init[i];
 		nvec_write_async(power->nvec, buf, 2);
 	}
@@ -117,91 +112,87 @@ static int nvec_power_bat_notifier(struct notifier_block *nb,
 	if (event_type != NVEC_BAT)
 		return NOTIFY_DONE;
 
-	switch(res->sub_type)
-	{
-		case SLOT_STATUS:
-			if (res->plc[0] & 1)
-			{
-				if (power->bat_present == 0)
-				{
-					status_changed = 1;
-					get_bat_mfg_data(power);
-				}
-
-				power->bat_present = 1;
-
-				switch ((res->plc[0] >> 1) & 3)
-				{
-					case 0:
-						power->bat_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-						break;
-					case 1:
-						power->bat_status = POWER_SUPPLY_STATUS_CHARGING;
-						break;
-					case 2:
-						power->bat_status = POWER_SUPPLY_STATUS_DISCHARGING;
-						break;
-					default:
-						power->bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
-				}
-			} else {
-				if (power->bat_present == 1)
-					status_changed = 1;
-
-				power->bat_present = 0;
+	switch (res->sub_type) {
+	case SLOT_STATUS:
+		if (res->plc[0] & 1) {
+			if (power->bat_present == 0) {
+				status_changed = 1;
+				get_bat_mfg_data(power);
+			}
+
+			power->bat_present = 1;
+
+			switch ((res->plc[0] >> 1) & 3) {
+			case 0:
+				power->bat_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+				break;
+			case 1:
+				power->bat_status = POWER_SUPPLY_STATUS_CHARGING;
+				break;
+			case 2:
+				power->bat_status = POWER_SUPPLY_STATUS_DISCHARGING;
+				break;
+			default:
 				power->bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
 			}
-			power->bat_cap = res->plc[1];
-			if (status_changed)
-				power_supply_changed(&nvec_bat_psy);
-			break;
-		case VOLTAGE:
-			power->bat_voltage_now = res->plu * 1000;
-			break;
-		case TIME_REMAINING:
-			power->time_remain = res->plu * 3600;
-			break;
-		case CURRENT:
-			power->bat_current_now = res->pls * 1000;
-			break;
-		case AVERAGE_CURRENT:
-			power->bat_current_avg = res->pls * 1000;
-			break;
-		case CAPACITY_REMAINING:
-			power->capacity_remain = res->plu * 1000;
-			break;
-		case LAST_FULL_CHARGE_CAPACITY:
-			power->charge_last_full = res->plu * 1000;
-			break;
-		case DESIGN_CAPACITY:
-			power->charge_full_design = res->plu * 1000;
-			break;
-		case CRITICAL_CAPACITY:
-			power->critical_capacity = res->plu * 1000;
-			break;
-		case TEMPERATURE:
-			power->bat_temperature = res->plu - 2732;
-			break;
-		case MANUFACTURER:
-			memcpy(power->bat_manu, &res->plc, res->length-2);
-			power->bat_model[res->length-2] = '\0';
-			break;
-		case MODEL:
-			memcpy(power->bat_model, &res->plc, res->length-2);
-			power->bat_model[res->length-2] = '\0';
-			break;
-		case TYPE:
-			memcpy(power->bat_type, &res->plc, res->length-2);
-			power->bat_type[res->length-2] = '\0';
-			/* this differs a little from the spec
-			   fill in more if you find some */
-			if (!strncmp(power->bat_type, "Li", 30))
-				power->bat_type_enum = POWER_SUPPLY_TECHNOLOGY_LION;
-			else
-				power->bat_type_enum = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-			break;
-		default:
-			return NOTIFY_STOP;
+		} else {
+			if (power->bat_present == 1)
+				status_changed = 1;
+
+			power->bat_present = 0;
+			power->bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
+		}
+		power->bat_cap = res->plc[1];
+		if (status_changed)
+			power_supply_changed(&nvec_bat_psy);
+		break;
+	case VOLTAGE:
+		power->bat_voltage_now = res->plu * 1000;
+		break;
+	case TIME_REMAINING:
+		power->time_remain = res->plu * 3600;
+		break;
+	case CURRENT:
+		power->bat_current_now = res->pls * 1000;
+		break;
+	case AVERAGE_CURRENT:
+		power->bat_current_avg = res->pls * 1000;
+		break;
+	case CAPACITY_REMAINING:
+		power->capacity_remain = res->plu * 1000;
+		break;
+	case LAST_FULL_CHARGE_CAPACITY:
+		power->charge_last_full = res->plu * 1000;
+		break;
+	case DESIGN_CAPACITY:
+		power->charge_full_design = res->plu * 1000;
+		break;
+	case CRITICAL_CAPACITY:
+		power->critical_capacity = res->plu * 1000;
+		break;
+	case TEMPERATURE:
+		power->bat_temperature = res->plu - 2732;
+		break;
+	case MANUFACTURER:
+		memcpy(power->bat_manu, &res->plc, res->length-2);
+		power->bat_model[res->length-2] = '\0';
+		break;
+	case MODEL:
+		memcpy(power->bat_model, &res->plc, res->length-2);
+		power->bat_model[res->length-2] = '\0';
+		break;
+	case TYPE:
+		memcpy(power->bat_type, &res->plc, res->length-2);
+		power->bat_type[res->length-2] = '\0';
+		/* this differs a little from the spec
+			fill in more if you find some */
+		if (!strncmp(power->bat_type, "Li", 30))
+			power->bat_type_enum = POWER_SUPPLY_TECHNOLOGY_LION;
+		else
+			power->bat_type_enum = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+		break;
+	default:
+		return NOTIFY_STOP;
 	}
 
 	return NOTIFY_STOP;
@@ -228,56 +219,55 @@ static int nvec_battery_get_property(struct power_supply *psy,
 {
 	struct nvec_power *power = dev_get_drvdata(psy->dev->parent);
 
-	switch(psp)
-	{
-		case POWER_SUPPLY_PROP_STATUS:
-			val->intval = power->bat_status;
-			break;
-		case POWER_SUPPLY_PROP_CAPACITY:
-			val->intval = power->bat_cap;
-			break;
-		case POWER_SUPPLY_PROP_PRESENT:
-			val->intval = power->bat_present;
-			break;
-		case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-			val->intval = power->bat_voltage_now;
-			break;
-		case POWER_SUPPLY_PROP_CURRENT_NOW:
-			val->intval = power->bat_current_now;
-			break;
-		case POWER_SUPPLY_PROP_CURRENT_AVG:
-			val->intval = power->bat_current_avg;
-			break;
-		case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
-			val->intval = power->time_remain;
-			break;
-		case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
-			val->intval = power->charge_full_design;
-			break;
-		case POWER_SUPPLY_PROP_CHARGE_FULL:
-			val->intval = power->charge_last_full;
-			break;
-		case POWER_SUPPLY_PROP_CHARGE_EMPTY:
-			val->intval = power->critical_capacity;
-			break;
-		case POWER_SUPPLY_PROP_CHARGE_NOW:
-			val->intval = power->capacity_remain;
-			break;
-		case POWER_SUPPLY_PROP_TEMP:
-			val->intval = power->bat_temperature;
-			break;
-		case POWER_SUPPLY_PROP_MANUFACTURER:
-			val->strval = power->bat_manu;
-			break;
-		case POWER_SUPPLY_PROP_MODEL_NAME:
-			val->strval = power->bat_model;
-			break;
-		case POWER_SUPPLY_PROP_TECHNOLOGY:
-			val->intval = power->bat_type_enum;
-			break;
-		default:
-			return -EINVAL;
-		}
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = power->bat_status;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = power->bat_cap;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = power->bat_present;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = power->bat_voltage_now;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = power->bat_current_now;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = power->bat_current_avg;
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
+		val->intval = power->time_remain;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = power->charge_full_design;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		val->intval = power->charge_last_full;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_EMPTY:
+		val->intval = power->critical_capacity;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		val->intval = power->capacity_remain;
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = power->bat_temperature;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = power->bat_manu;
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = power->bat_model;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = power->bat_type_enum;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -328,8 +318,7 @@ static struct power_supply nvec_psy = {
 };
 
 static int counter = 0;
-static int const bat_iter[] =
-{
+static int const bat_iter[] = {
 	SLOT_STATUS, VOLTAGE, CURRENT, CAPACITY_REMAINING,
 #ifdef EC_FULL_DIAG
 	AVERAGE_CURRENT, TEMPERATURE, TIME_REMAINING,
@@ -352,11 +341,9 @@ static void nvec_power_poll(struct work_struct *work)
 /* select a battery request function via round robin
    doing it all at once seems to overload the power supply */
 	buf[0] = '\x02'; /* battery */
-        buf[1] = bat_iter[counter++];
+	buf[1] = bat_iter[counter++];
 	nvec_write_async(power->nvec, buf, 2);
 
-//	printk("%02x %02x\n", buf[0], buf[1]);
-
 	schedule_delayed_work(to_delayed_work(work), msecs_to_jiffies(5000));
 };
 
@@ -381,7 +368,7 @@ static int __devinit nvec_power_probe(struct platform_device *pdev)
 	case BAT:
 		psy = &nvec_bat_psy;
 
-                power->notifier.notifier_call = nvec_power_bat_notifier;
+		power->notifier.notifier_call = nvec_power_bat_notifier;
 		break;
 	default:
 		kfree(power);
@@ -398,14 +385,13 @@ static int __devinit nvec_power_probe(struct platform_device *pdev)
 
 static struct platform_driver nvec_power_driver = {
 	.probe = nvec_power_probe,
-//	.remove = __devexit_p(nvec_power_remove),
 	.driver = {
 		.name = "nvec-power",
 		.owner = THIS_MODULE,
 	}
 };
 
-static int __init nvec_power_init(void) 
+static int __init nvec_power_init(void)
 {
 	return platform_driver_register(&nvec_power_driver);
 }
diff --git a/drivers/staging/nvec/nvec_ps2.c b/drivers/staging/nvec/nvec_ps2.c
index 6bb9430..d8e9fd0 100644
--- a/drivers/staging/nvec/nvec_ps2.c
+++ b/drivers/staging/nvec/nvec_ps2.c
@@ -3,12 +3,11 @@
 #include <linux/delay.h>
 #include "nvec.h"
 
-#define START_STREAMING	{'\x06','\x03','\x01'}
-#define STOP_STREAMING	{'\x06','\x04'}
-#define SEND_COMMAND	{'\x06','\x01','\xf4','\x01'}
+#define START_STREAMING	{'\x06', '\x03', '\x01'}
+#define STOP_STREAMING	{'\x06', '\x04'}
+#define SEND_COMMAND	{'\x06', '\x01', '\xf4', '\x01'}
 
-struct nvec_ps2
-{
+struct nvec_ps2 {
 	struct serio *ser_dev;
 	struct notifier_block notifier;
 	struct nvec_chip *nvec;
@@ -54,23 +53,22 @@ static int nvec_ps2_notifier(struct notifier_block *nb,
 	unsigned char *msg = (unsigned char *)data;
 
 	switch (event_type) {
-		case NVEC_PS2_EVT:
-			serio_interrupt(ps2_dev.ser_dev, msg[2], 0);
-			return NOTIFY_STOP;
-
-		case NVEC_PS2:
-			if (msg[2] == 1)
-				for(i = 0; i < (msg[1] - 2); i++)
-					serio_interrupt(ps2_dev.ser_dev, msg[i+4], 0);
-			else if (msg[1] != 2) /* !ack */
-			{
-				printk("nvec_ps2: unhandled mouse event ");
-				for(i = 0; i <= (msg[1]+1); i++)
-					printk("%02x ", msg[i]);
-				printk(".\n");
-			}
-
-			return NOTIFY_STOP;
+	case NVEC_PS2_EVT:
+		serio_interrupt(ps2_dev.ser_dev, msg[2], 0);
+		return NOTIFY_STOP;
+
+	case NVEC_PS2:
+		if (msg[2] == 1)
+			for (i = 0; i < (msg[1] - 2); i++)
+				serio_interrupt(ps2_dev.ser_dev, msg[i+4], 0);
+		else if (msg[1] != 2) { /* !ack */
+			printk("nvec_ps2: unhandled mouse event ");
+			for (i = 0; i <= (msg[1]+1); i++)
+				printk("%02x ", msg[i]);
+			printk(".\n");
+		}
+
+		return NOTIFY_STOP;
 	}
 
 	return NOTIFY_DONE;
@@ -81,10 +79,10 @@ int __init nvec_ps2(struct nvec_chip *nvec)
 {
 	struct serio *ser_dev = kzalloc(sizeof(struct serio), GFP_KERNEL);
 
-	ser_dev->id.type=SERIO_8042;
-	ser_dev->write=ps2_sendcommand;
-	ser_dev->open=ps2_startstreaming;
-	ser_dev->close=ps2_stopstreaming;
+	ser_dev->id.type = SERIO_8042;
+	ser_dev->write = ps2_sendcommand;
+	ser_dev->open = ps2_startstreaming;
+	ser_dev->close = ps2_stopstreaming;
 
 	strlcpy(ser_dev->name, "NVEC PS2", sizeof(ser_dev->name));
 	strlcpy(ser_dev->phys, "NVEC I2C slave", sizeof(ser_dev->phys));
-- 
1.7.5.4

