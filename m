Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab1CDR52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:57:28 -0500
Received: from imr4.ericy.com ([198.24.6.8]:40508 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab1CDR5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:10 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 02/11] hwmon: (w83627ehf) Fixed most checkpatch warnings and errors
Date: Fri, 4 Mar 2011 09:57:57 -0800
Message-ID: <1299261486-15190-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup fixes most of the checkpatch warnings and errors in the w83627ehf
driver. Remaining warnings and errors are left untouched on purpose to avoid
making the code less readable.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 drivers/hwmon/w83627ehf.c |  149 +++++++++++++++++++++++++-------------------
 1 files changed, 85 insertions(+), 64 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 66e6855..1128eac 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1,10 +1,10 @@
 /*
     w83627ehf - Driver for the hardware monitoring functionality of
-                the Winbond W83627EHF Super-I/O chip
+		the Winbond W83627EHF Super-I/O chip
     Copyright (C) 2005  Jean Delvare <khali@linux-fr.org>
     Copyright (C) 2006  Yuan Mu (Winbond),
-                        Rudolf Marek <r.marek@assembler.cz>
-                        David Hubbard <david.c.hubbard@gmail.com>
+			Rudolf Marek <r.marek@assembler.cz>
+			David Hubbard <david.c.hubbard@gmail.com>
 			Daniel J Blueman <daniel.blueman@gmail.com>
 
     Shamelessly ripped from the w83627hf driver
@@ -35,7 +35,7 @@
 
     Chip        #vin    #fan    #pwm    #temp  chip IDs       man ID
     w83627ehf   10      5       4       3      0x8850 0x88    0x5ca3
-                                               0x8860 0xa1
+					       0x8860 0xa1
     w83627dhg    9      5       4       3      0xa020 0xc1    0x5ca3
     w83627dhg-p  9      5       4       3      0xb070 0xc1    0x5ca3
     w83667hg     9      5       3       3      0xa510 0xc1    0x5ca3
@@ -61,7 +61,7 @@
 enum kinds { w83627ehf, w83627dhg, w83627dhg_p, w83667hg, w83667hg_b };
 
 /* used to set data->name = w83627ehf_device_names[data->sio_kind] */
-static const char * w83627ehf_device_names[] = {
+static const char * const w83627ehf_device_names[] = {
 	"w83627ehf",
 	"w83627dhg",
 	"w83627dhg",
@@ -80,7 +80,7 @@ MODULE_PARM_DESC(force_id, "Override the detected device ID");
  */
 
 #define W83627EHF_LD_HWM	0x0b
-#define W83667HG_LD_VID 	0x0d
+#define W83667HG_LD_VID		0x0d
 
 #define SIO_REG_LDSEL		0x07	/* Logical device select */
 #define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
@@ -94,7 +94,7 @@ MODULE_PARM_DESC(force_id, "Override the detected device ID");
 #define SIO_W83627EHG_ID	0x8860
 #define SIO_W83627DHG_ID	0xa020
 #define SIO_W83627DHG_P_ID	0xb070
-#define SIO_W83667HG_ID 	0xa510
+#define SIO_W83667HG_ID		0xa510
 #define SIO_W83667HG_B_ID	0xb350
 #define SIO_ID_MASK		0xFFF0
 
@@ -138,7 +138,7 @@ superio_exit(int ioreg)
  * ISA constants
  */
 
-#define IOREGION_ALIGNMENT	~7
+#define IOREGION_ALIGNMENT	(~7)
 #define IOREGION_OFFSET		5
 #define IOREGION_LENGTH		2
 #define ADDR_REG_OFFSET		0
@@ -279,7 +279,8 @@ static inline long in_from_reg(u8 reg, u8 nr)
 
 static inline u8 in_to_reg(u32 val, u8 nr)
 {
-	return SENSORS_LIMIT(((val + (scale_in[nr] / 2)) / scale_in[nr]), 0, 255);
+	return SENSORS_LIMIT(((val + (scale_in[nr] / 2)) / scale_in[nr]), 0,
+			     255);
 }
 
 /*
@@ -321,7 +322,8 @@ struct w83627ehf_data {
 	u8 pwm_enable[4]; /* 1->manual
 			     2->thermal cruise mode (also called SmartFan I)
 			     3->fan speed cruise mode
-			     4->variable thermal cruise (also called SmartFan III) */
+			     4->variable thermal cruise (also called
+				SmartFan III) */
 	u8 pwm_num;		/* number of pwm */
 	u8 pwm[4];
 	u8 target_temp[4];
@@ -384,7 +386,8 @@ static u16 w83627ehf_read_value(struct w83627ehf_data *data, u16 reg)
 	return res;
 }
 
-static int w83627ehf_write_value(struct w83627ehf_data *data, u16 reg, u16 value)
+static int w83627ehf_write_value(struct w83627ehf_data *data, u16 reg,
+				 u16 value)
 {
 	int word_sized = is_word_sized(reg);
 
@@ -518,7 +521,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			   time */
 			if (data->fan[i] == 0xff
 			 && data->fan_div[i] < 0x07) {
-			 	dev_dbg(dev, "Increasing fan%d "
+				dev_dbg(dev, "Increasing fan%d "
 					"clock divider from %u to %u\n",
 					i + 1, div_from_reg(data->fan_div[i]),
 					div_from_reg(data->fan_div[i] + 1));
@@ -548,16 +551,16 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 				((pwmcfg >> W83627EHF_PWM_MODE_SHIFT[i]) & 1)
 				? 0 : 1;
 			data->pwm_enable[i] =
-					((pwmcfg >> W83627EHF_PWM_ENABLE_SHIFT[i])
-						& 3) + 1;
+				((pwmcfg >> W83627EHF_PWM_ENABLE_SHIFT[i])
+				& 3) + 1;
 			data->pwm[i] = w83627ehf_read_value(data,
 						W83627EHF_REG_PWM[i]);
 			data->fan_start_output[i] = w83627ehf_read_value(data,
-						W83627EHF_REG_FAN_START_OUTPUT[i]);
+					W83627EHF_REG_FAN_START_OUTPUT[i]);
 			data->fan_stop_output[i] = w83627ehf_read_value(data,
-						W83627EHF_REG_FAN_STOP_OUTPUT[i]);
+					W83627EHF_REG_FAN_STOP_OUTPUT[i]);
 			data->fan_stop_time[i] = w83627ehf_read_value(data,
-						W83627EHF_REG_FAN_STOP_TIME[i]);
+					W83627EHF_REG_FAN_STOP_TIME[i]);
 
 			if (data->REG_FAN_MAX_OUTPUT[i] != 0xff)
 				data->fan_max_output[i] =
@@ -611,7 +614,8 @@ show_##reg(struct device *dev, struct device_attribute *attr, \
 	   char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%ld\n", in_from_reg(data->reg[nr], nr)); \
 }
@@ -621,11 +625,12 @@ show_in_reg(in_max)
 
 #define store_in_reg(REG, reg) \
 static ssize_t \
-store_in_##reg (struct device *dev, struct device_attribute *attr, \
-			const char *buf, size_t count) \
+store_in_##reg(struct device *dev, struct device_attribute *attr, \
+	       const char *buf, size_t count) \
 { \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
@@ -643,7 +648,8 @@ store_in_##reg (struct device *dev, struct device_attribute *attr, \
 store_in_reg(MIN, min)
 store_in_reg(MAX, max)
 
-static ssize_t show_alarm(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
+			  char *buf)
 {
 	struct w83627ehf_data *data = w83627ehf_update_device(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
@@ -678,29 +684,29 @@ static struct sensor_device_attribute sda_in_alarm[] = {
 };
 
 static struct sensor_device_attribute sda_in_min[] = {
-       SENSOR_ATTR(in0_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 0),
-       SENSOR_ATTR(in1_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 1),
-       SENSOR_ATTR(in2_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 2),
-       SENSOR_ATTR(in3_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 3),
-       SENSOR_ATTR(in4_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 4),
-       SENSOR_ATTR(in5_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 5),
-       SENSOR_ATTR(in6_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 6),
-       SENSOR_ATTR(in7_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 7),
-       SENSOR_ATTR(in8_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 8),
-       SENSOR_ATTR(in9_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 9),
+	SENSOR_ATTR(in0_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 0),
+	SENSOR_ATTR(in1_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 1),
+	SENSOR_ATTR(in2_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 2),
+	SENSOR_ATTR(in3_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 3),
+	SENSOR_ATTR(in4_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 4),
+	SENSOR_ATTR(in5_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 5),
+	SENSOR_ATTR(in6_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 6),
+	SENSOR_ATTR(in7_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 7),
+	SENSOR_ATTR(in8_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 8),
+	SENSOR_ATTR(in9_min, S_IWUSR | S_IRUGO, show_in_min, store_in_min, 9),
 };
 
 static struct sensor_device_attribute sda_in_max[] = {
-       SENSOR_ATTR(in0_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 0),
-       SENSOR_ATTR(in1_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 1),
-       SENSOR_ATTR(in2_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 2),
-       SENSOR_ATTR(in3_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 3),
-       SENSOR_ATTR(in4_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 4),
-       SENSOR_ATTR(in5_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 5),
-       SENSOR_ATTR(in6_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 6),
-       SENSOR_ATTR(in7_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 7),
-       SENSOR_ATTR(in8_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 8),
-       SENSOR_ATTR(in9_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 9),
+	SENSOR_ATTR(in0_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 0),
+	SENSOR_ATTR(in1_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 1),
+	SENSOR_ATTR(in2_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 2),
+	SENSOR_ATTR(in3_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 3),
+	SENSOR_ATTR(in4_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 4),
+	SENSOR_ATTR(in5_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 5),
+	SENSOR_ATTR(in6_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 6),
+	SENSOR_ATTR(in7_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 7),
+	SENSOR_ATTR(in8_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 8),
+	SENSOR_ATTR(in9_max, S_IWUSR | S_IRUGO, show_in_max, store_in_max, 9),
 };
 
 #define show_fan_reg(reg) \
@@ -709,7 +715,8 @@ show_##reg(struct device *dev, struct device_attribute *attr, \
 	   char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
 		       fan_from_reg(data->reg[nr], \
@@ -847,7 +854,8 @@ show_##reg(struct device *dev, struct device_attribute *attr, \
 	   char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
 		       temp_from_reg(W83627EHF_REG_##REG[nr], data->reg[nr])); \
@@ -862,7 +870,8 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 	    const char *buf, size_t count) \
 { \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	int err; \
 	long val; \
@@ -925,11 +934,12 @@ static struct sensor_device_attribute sda_temp_type[] = {
 };
 
 #define show_pwm_reg(reg) \
-static ssize_t show_##reg (struct device *dev, struct device_attribute *attr, \
-				char *buf) \
+static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
+			  char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", data->reg[nr]); \
 }
@@ -1022,7 +1032,8 @@ static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
 				char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", data->reg[nr] * 1000); \
 }
@@ -1141,16 +1152,18 @@ static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
 		       char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", data->reg[nr]); \
-}\
+} \
 static ssize_t \
 store_##reg(struct device *dev, struct device_attribute *attr, \
 			    const char *buf, size_t count) \
-{\
+{ \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
@@ -1175,10 +1188,12 @@ static ssize_t show_##reg(struct device *dev, struct device_attribute *attr, \
 				char *buf) \
 { \
 	struct w83627ehf_data *data = w83627ehf_update_device(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	return sprintf(buf, "%d\n", \
-			step_time_from_reg(data->reg[nr], data->pwm_mode[nr])); \
+			step_time_from_reg(data->reg[nr], \
+					   data->pwm_mode[nr])); \
 } \
 \
 static ssize_t \
@@ -1186,7 +1201,8 @@ store_##reg(struct device *dev, struct device_attribute *attr, \
 			const char *buf, size_t count) \
 { \
 	struct w83627ehf_data *data = dev_get_drvdata(dev); \
-	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr); \
+	struct sensor_device_attribute *sensor_attr = \
+		to_sensor_dev_attr(attr); \
 	int nr = sensor_attr->index; \
 	unsigned long val; \
 	int err; \
@@ -1387,7 +1403,8 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	if (!(data = kzalloc(sizeof(struct w83627ehf_data), GFP_KERNEL))) {
+	data = kzalloc(sizeof(struct w83627ehf_data), GFP_KERNEL);
+	if (!data) {
 		err = -ENOMEM;
 		goto exit_release;
 	}
@@ -1508,10 +1525,11 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	w83627ehf_update_fan_div(data);
 
 	/* Register sysfs hooks */
-  	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++)
-		if ((err = device_create_file(dev,
-			&sda_sf3_arrays[i].dev_attr)))
+	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++) {
+		err = device_create_file(dev, &sda_sf3_arrays[i].dev_attr);
+		if (err)
 			goto exit_remove;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(sda_sf3_max_step_arrays); i++) {
 		struct sensor_device_attribute *attr =
@@ -1525,8 +1543,9 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	/* if fan4 is enabled create the sf3 files for it */
 	if ((data->has_fan & (1 << 3)) && data->pwm_num >= 4)
 		for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays_fan4); i++) {
-			if ((err = device_create_file(dev,
-				&sda_sf3_arrays_fan4[i].dev_attr)))
+			err = device_create_file(dev,
+					&sda_sf3_arrays_fan4[i].dev_attr);
+			if (err)
 				goto exit_remove;
 		}
 
@@ -1696,7 +1715,8 @@ static int __init w83627ehf_find(int sioaddr, unsigned short *addr,
 	/* Activate logical device if needed */
 	val = superio_inb(sioaddr, SIO_REG_ENABLE);
 	if (!(val & 0x01)) {
-		pr_warn("Forcibly enabling Super-I/O. Sensor is probably unusable.\n");
+		pr_warn("Forcibly enabling Super-I/O. "
+			"Sensor is probably unusable.\n");
 		superio_outb(sioaddr, SIO_REG_ENABLE, val | 0x01);
 	}
 
@@ -1733,7 +1753,8 @@ static int __init sensors_w83627ehf_init(void)
 	if (err)
 		goto exit;
 
-	if (!(pdev = platform_device_alloc(DRVNAME, address))) {
+	pdev = platform_device_alloc(DRVNAME, address);
+	if (!pdev) {
 		err = -ENOMEM;
 		pr_err("Device allocation failed\n");
 		goto exit_unregister;
-- 
1.7.3.1

