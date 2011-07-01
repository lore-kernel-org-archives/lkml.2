Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1GACTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:19:24 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49453 "HELO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754461Ab1GACTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:15 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 02/11] misc: mpu3050 Register definition and Private data
Date: Thu, 30 Jun 2011 19:18:18 -0700
Message-Id: <1309486707-1658-2-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPU3050 registers and internal data configuration definion file for the
inv_mpu driver.

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---
 drivers/misc/inv_mpu/mldl_cfg.h |  374 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/inv_mpu/mpu3050.h  |  251 ++++++++++++++++++++++++++
 2 files changed, 625 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/mldl_cfg.h
 create mode 100644 drivers/misc/inv_mpu/mpu3050.h

diff --git a/drivers/misc/inv_mpu/mldl_cfg.h b/drivers/misc/inv_mpu/mldl_cfg.h
new file mode 100644
index 0000000..457477b
--- /dev/null
+++ b/drivers/misc/inv_mpu/mldl_cfg.h
@@ -0,0 +1,374 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+/**
+ *  @addtogroup MLDL
+ *
+ *  @{
+ *      @file   mldl_cfg.h
+ *      @brief  The Motion Library Driver Layer Configuration header file.
+ */
+
+#ifndef __MLDL_CFG_H__
+#define __MLDL_CFG_H__
+
+#include "mltypes.h"
+#include "mlsl.h"
+#include <linux/mpu.h>
+#  include "mpu3050.h"
+
+#include "log.h"
+
+/*************************************************************************
+ *  Sensors Bit definitions
+ *************************************************************************/
+
+#define INV_X_GYRO			(0x0001)
+#define INV_Y_GYRO			(0x0002)
+#define INV_Z_GYRO			(0x0004)
+#define INV_DMP_PROCESSOR		(0x0008)
+
+#define INV_X_ACCEL			(0x0010)
+#define INV_Y_ACCEL			(0x0020)
+#define INV_Z_ACCEL			(0x0040)
+
+#define INV_X_COMPASS			(0x0080)
+#define INV_Y_COMPASS			(0x0100)
+#define INV_Z_COMPASS			(0x0200)
+
+#define INV_X_PRESSURE			(0x0300)
+#define INV_Y_PRESSURE			(0x0800)
+#define INV_Z_PRESSURE			(0x1000)
+
+#define INV_TEMPERATURE			(0x2000)
+#define INV_TIME			(0x4000)
+
+#define INV_THREE_AXIS_GYRO		(0x000F)
+#define INV_THREE_AXIS_ACCEL		(0x0070)
+#define INV_THREE_AXIS_COMPASS		(0x0380)
+#define INV_THREE_AXIS_PRESSURE		(0x1C00)
+
+#define INV_FIVE_AXIS			(0x007B)
+#define INV_SIX_AXIS_GYRO_ACCEL		(0x007F)
+#define INV_SIX_AXIS_ACCEL_COMPASS	(0x03F0)
+#define INV_NINE_AXIS			(0x03FF)
+#define INV_ALL_SENSORS			(0x7FFF)
+
+#define MPL_PROD_KEY(ver, rev) (ver * 100 + rev)
+
+/* -------------------------------------------------------------------------- */
+struct mpu_ram {
+	__u16 length;
+	__u8 *ram;
+};
+
+struct mpu_gyro_cfg {
+	__u8 int_config;
+	__u8 ext_sync;
+	__u8 full_scale;
+	__u8 lpf;
+	__u8 clk_src;
+	__u8 divider;
+	__u8 dmp_enable;
+	__u8 fifo_enable;
+	__u8 dmp_cfg1;
+	__u8 dmp_cfg2;
+};
+
+/* Offset registers that can be calibrated */
+struct mpu_offsets {
+	__u8	tc[GYRO_NUM_AXES];
+	__u16	gyro[GYRO_NUM_AXES];
+};
+
+/* Chip related information that can be read and verified */
+struct mpu_chip_info {
+	__u8 addr;
+	__u8 product_revision;
+	__u8 silicon_revision;
+	__u8 product_id;
+	__u16 gyro_sens_trim;
+	/* Only used for MPU6050 */
+	__u16 accel_sens_trim;
+};
+
+
+struct inv_mpu_cfg {
+	__u32 requested_sensors;
+	__u8 ignore_system_suspend;
+};
+
+/* Driver related state information */
+struct inv_mpu_state {
+#define MPU_GYRO_IS_SUSPENDED		(0x01 << EXT_SLAVE_TYPE_GYROSCOPE)
+#define MPU_ACCEL_IS_SUSPENDED		(0x01 << EXT_SLAVE_TYPE_ACCEL)
+#define MPU_COMPASS_IS_SUSPENDED	(0x01 << EXT_SLAVE_TYPE_COMPASS)
+#define MPU_PRESSURE_IS_SUSPENDED	(0x01 << EXT_SLAVE_TYPE_PRESSURE)
+#define MPU_GYRO_IS_BYPASSED		(0x10)
+#define MPU_DMP_IS_SUSPENDED		(0x20)
+#define MPU_GYRO_NEEDS_RESET		(0x40)
+	__u8 status;
+	/* 0-1 for 3050, bitfield of BIT_SLVx_DLY_EN, x = [0..4] */
+	__u8 i2c_slaves_enabled;
+};
+
+/* Platform data for the MPU */
+struct mldl_cfg {
+	struct mpu_ram			*mpu_ram;
+	struct mpu_gyro_cfg		*mpu_gyro_cfg;
+	struct mpu_offsets		*mpu_offsets;
+	struct mpu_chip_info		*mpu_chip_info;
+
+	/* MPU Related stored status and info */
+	struct inv_mpu_cfg		*inv_mpu_cfg;
+	struct inv_mpu_state		*inv_mpu_state;
+
+	/* Slave related information */
+	struct ext_slave_descr		*slave[EXT_SLAVE_NUM_TYPES];
+	/* Platform Data */
+	struct mpu_platform_data	*pdata;
+	struct ext_slave_platform_data	*pdata_slave[EXT_SLAVE_NUM_TYPES];
+};
+
+/* -------------------------------------------------------------------------- */
+
+int inv_mpu_open(struct mldl_cfg *mldl_cfg,
+		 void *mlsl_handle,
+		 void *accel_handle,
+		 void *compass_handle,
+		 void *pressure_handle);
+int inv_mpu_close(struct mldl_cfg *mldl_cfg,
+		  void *mlsl_handle,
+		  void *accel_handle,
+		  void *compass_handle,
+		  void *pressure_handle);
+int inv_mpu_resume(struct mldl_cfg *mldl_cfg,
+		   void *gyro_handle,
+		   void *accel_handle,
+		   void *compass_handle,
+		   void *pressure_handle,
+		   unsigned long sensors);
+int inv_mpu_suspend(struct mldl_cfg *mldl_cfg,
+		    void *gyro_handle,
+		    void *accel_handle,
+		    void *compass_handle,
+		    void *pressure_handle,
+		    unsigned long sensors);
+
+/* Slave Read functions */
+int inv_mpu_slave_read(struct mldl_cfg *mldl_cfg,
+		       void *gyro_handle,
+		       void *slave_handle,
+		       struct ext_slave_descr *slave,
+		       struct ext_slave_platform_data *pdata,
+		       unsigned char *data);
+static inline int inv_mpu_read_accel(struct mldl_cfg *mldl_cfg,
+				     void *gyro_handle,
+				     void *accel_handle, unsigned char *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_read(
+		mldl_cfg, gyro_handle, accel_handle,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_ACCEL],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_ACCEL],
+		data);
+}
+
+static inline int inv_mpu_read_compass(struct mldl_cfg *mldl_cfg,
+				       void *gyro_handle,
+				       void *compass_handle,
+				       unsigned char *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_read(
+		mldl_cfg, gyro_handle, compass_handle,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_COMPASS],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_COMPASS],
+		data);
+}
+
+static inline int inv_mpu_read_pressure(struct mldl_cfg *mldl_cfg,
+					void *gyro_handle,
+					void *pressure_handle,
+					unsigned char *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_read(
+		mldl_cfg, gyro_handle, pressure_handle,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_PRESSURE],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_PRESSURE],
+		data);
+}
+
+int gyro_config(void *mlsl_handle,
+		struct mldl_cfg *mldl_cfg,
+		struct ext_slave_config *data);
+
+/* Slave Config functions */
+int inv_mpu_slave_config(struct mldl_cfg *mldl_cfg,
+			 void *gyro_handle,
+			 void *slave_handle,
+			 struct ext_slave_config *data,
+			 struct ext_slave_descr *slave,
+			 struct ext_slave_platform_data *pdata);
+static inline int inv_mpu_config_accel(struct mldl_cfg *mldl_cfg,
+				       void *gyro_handle,
+				       void *accel_handle,
+				       struct ext_slave_config *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_config(
+		mldl_cfg, gyro_handle, accel_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_ACCEL],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_ACCEL]);
+}
+
+static inline int inv_mpu_config_compass(struct mldl_cfg *mldl_cfg,
+					 void *gyro_handle,
+					 void *compass_handle,
+					 struct ext_slave_config *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_config(
+		mldl_cfg, gyro_handle, compass_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_COMPASS],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_COMPASS]);
+}
+
+static inline int inv_mpu_config_pressure(struct mldl_cfg *mldl_cfg,
+					  void *gyro_handle,
+					  void *pressure_handle,
+					  struct ext_slave_config *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_slave_config(
+		mldl_cfg, gyro_handle, pressure_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_PRESSURE],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_PRESSURE]);
+}
+
+int gyro_get_config(void *mlsl_handle,
+		struct mldl_cfg *mldl_cfg,
+		struct ext_slave_config *data);
+
+/* Slave get config functions */
+int inv_mpu_get_slave_config(struct mldl_cfg *mldl_cfg,
+			     void *gyro_handle,
+			     void *slave_handle,
+			     struct ext_slave_config *data,
+			     struct ext_slave_descr *slave,
+			     struct ext_slave_platform_data *pdata);
+
+static inline int inv_mpu_get_accel_config(struct mldl_cfg *mldl_cfg,
+					   void *gyro_handle,
+					   void *accel_handle,
+					   struct ext_slave_config *data)
+{
+	if (!mldl_cfg) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_get_slave_config(
+		mldl_cfg, gyro_handle, accel_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_ACCEL],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_ACCEL]);
+}
+
+static inline int inv_mpu_get_compass_config(struct mldl_cfg *mldl_cfg,
+					     void *gyro_handle,
+					     void *compass_handle,
+					     struct ext_slave_config *data)
+{
+	if (!mldl_cfg || !(mldl_cfg->pdata)) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_get_slave_config(
+		mldl_cfg, gyro_handle, compass_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_COMPASS],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_COMPASS]);
+}
+
+static inline int inv_mpu_get_pressure_config(struct mldl_cfg *mldl_cfg,
+					      void *gyro_handle,
+					      void *pressure_handle,
+					      struct ext_slave_config *data)
+{
+	if (!mldl_cfg || !(mldl_cfg->pdata)) {
+		LOG_RESULT_LOCATION(INV_ERROR_INVALID_PARAMETER);
+		return INV_ERROR_INVALID_PARAMETER;
+	}
+
+	return inv_mpu_get_slave_config(
+		mldl_cfg, gyro_handle, pressure_handle, data,
+		mldl_cfg->slave[EXT_SLAVE_TYPE_PRESSURE],
+		mldl_cfg->pdata_slave[EXT_SLAVE_TYPE_PRESSURE]);
+}
+
+/* -------------------------------------------------------------------------- */
+
+static inline
+long inv_mpu_get_sampling_rate_hz(struct mpu_gyro_cfg *gyro_cfg)
+{
+	if (((gyro_cfg->lpf) == 0) || ((gyro_cfg->lpf) == 7))
+		return 8000L / (gyro_cfg->divider + 1);
+	else
+		return 1000L / (gyro_cfg->divider + 1);
+}
+
+static inline
+long inv_mpu_get_sampling_period_us(struct mpu_gyro_cfg *gyro_cfg)
+{
+	if (((gyro_cfg->lpf) == 0) || ((gyro_cfg->lpf) == 7))
+		return (long) (1000000L * (gyro_cfg->divider + 1)) / 8000L;
+	else
+		return (long) (1000000L * (gyro_cfg->divider + 1)) / 1000L;
+}
+
+#endif				/* __MLDL_CFG_H__ */
+
+/**
+ * @}
+ */
diff --git a/drivers/misc/inv_mpu/mpu3050.h b/drivers/misc/inv_mpu/mpu3050.h
new file mode 100644
index 0000000..02af16e
--- /dev/null
+++ b/drivers/misc/inv_mpu/mpu3050.h
@@ -0,0 +1,251 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#ifndef __MPU_H_
+#error Do not include this file directly.  Include mpu.h instead.
+#endif
+
+#ifndef __MPU3050_H_
+#define __MPU3050_H_
+
+#include <linux/types.h>
+
+
+#define MPU_NAME "mpu3050"
+#define DEFAULT_MPU_SLAVEADDR       0x68
+
+/*==== MPU REGISTER SET ====*/
+enum mpu_register {
+	MPUREG_WHO_AM_I = 0,	/* 00 0x00 */
+	MPUREG_PRODUCT_ID,	/* 01 0x01 */
+	MPUREG_02_RSVD,		/* 02 0x02 */
+	MPUREG_03_RSVD,		/* 03 0x03 */
+	MPUREG_04_RSVD,		/* 04 0x04 */
+	MPUREG_XG_OFFS_TC,	/* 05 0x05 */
+	MPUREG_06_RSVD,		/* 06 0x06 */
+	MPUREG_07_RSVD,		/* 07 0x07 */
+	MPUREG_YG_OFFS_TC,	/* 08 0x08 */
+	MPUREG_09_RSVD,		/* 09 0x09 */
+	MPUREG_0A_RSVD,		/* 10 0x0a */
+	MPUREG_ZG_OFFS_TC,	/* 11 0x0b */
+	MPUREG_X_OFFS_USRH,	/* 12 0x0c */
+	MPUREG_X_OFFS_USRL,	/* 13 0x0d */
+	MPUREG_Y_OFFS_USRH,	/* 14 0x0e */
+	MPUREG_Y_OFFS_USRL,	/* 15 0x0f */
+	MPUREG_Z_OFFS_USRH,	/* 16 0x10 */
+	MPUREG_Z_OFFS_USRL,	/* 17 0x11 */
+	MPUREG_FIFO_EN1,	/* 18 0x12 */
+	MPUREG_FIFO_EN2,	/* 19 0x13 */
+	MPUREG_AUX_SLV_ADDR,	/* 20 0x14 */
+	MPUREG_SMPLRT_DIV,	/* 21 0x15 */
+	MPUREG_DLPF_FS_SYNC,	/* 22 0x16 */
+	MPUREG_INT_CFG,		/* 23 0x17 */
+	MPUREG_ACCEL_BURST_ADDR,/* 24 0x18 */
+	MPUREG_19_RSVD,		/* 25 0x19 */
+	MPUREG_INT_STATUS,	/* 26 0x1a */
+	MPUREG_TEMP_OUT_H,	/* 27 0x1b */
+	MPUREG_TEMP_OUT_L,	/* 28 0x1c */
+	MPUREG_GYRO_XOUT_H,	/* 29 0x1d */
+	MPUREG_GYRO_XOUT_L,	/* 30 0x1e */
+	MPUREG_GYRO_YOUT_H,	/* 31 0x1f */
+	MPUREG_GYRO_YOUT_L,	/* 32 0x20 */
+	MPUREG_GYRO_ZOUT_H,	/* 33 0x21 */
+	MPUREG_GYRO_ZOUT_L,	/* 34 0x22 */
+	MPUREG_23_RSVD,		/* 35 0x23 */
+	MPUREG_24_RSVD,		/* 36 0x24 */
+	MPUREG_25_RSVD,		/* 37 0x25 */
+	MPUREG_26_RSVD,		/* 38 0x26 */
+	MPUREG_27_RSVD,		/* 39 0x27 */
+	MPUREG_28_RSVD,		/* 40 0x28 */
+	MPUREG_29_RSVD,		/* 41 0x29 */
+	MPUREG_2A_RSVD,		/* 42 0x2a */
+	MPUREG_2B_RSVD,		/* 43 0x2b */
+	MPUREG_2C_RSVD,		/* 44 0x2c */
+	MPUREG_2D_RSVD,		/* 45 0x2d */
+	MPUREG_2E_RSVD,		/* 46 0x2e */
+	MPUREG_2F_RSVD,		/* 47 0x2f */
+	MPUREG_30_RSVD,		/* 48 0x30 */
+	MPUREG_31_RSVD,		/* 49 0x31 */
+	MPUREG_32_RSVD,		/* 50 0x32 */
+	MPUREG_33_RSVD,		/* 51 0x33 */
+	MPUREG_34_RSVD,		/* 52 0x34 */
+	MPUREG_DMP_CFG_1,	/* 53 0x35 */
+	MPUREG_DMP_CFG_2,	/* 54 0x36 */
+	MPUREG_BANK_SEL,	/* 55 0x37 */
+	MPUREG_MEM_START_ADDR,	/* 56 0x38 */
+	MPUREG_MEM_R_W,		/* 57 0x39 */
+	MPUREG_FIFO_COUNTH,	/* 58 0x3a */
+	MPUREG_FIFO_COUNTL,	/* 59 0x3b */
+	MPUREG_FIFO_R_W,	/* 60 0x3c */
+	MPUREG_USER_CTRL,	/* 61 0x3d */
+	MPUREG_PWR_MGM,		/* 62 0x3e */
+	MPUREG_3F_RSVD,		/* 63 0x3f */
+	NUM_OF_MPU_REGISTERS	/* 64 0x40 */
+};
+
+/*==== BITS FOR MPU ====*/
+
+/*---- MPU 'FIFO_EN1' register (12) ----*/
+#define BIT_TEMP_OUT                0x80
+#define BIT_GYRO_XOUT               0x40
+#define BIT_GYRO_YOUT               0x20
+#define BIT_GYRO_ZOUT               0x10
+#define BIT_ACCEL_XOUT              0x08
+#define BIT_ACCEL_YOUT              0x04
+#define BIT_ACCEL_ZOUT              0x02
+#define BIT_AUX_1OUT                0x01
+/*---- MPU 'FIFO_EN2' register (13) ----*/
+#define BIT_AUX_2OUT                0x02
+#define BIT_AUX_3OUT                0x01
+/*---- MPU 'DLPF_FS_SYNC' register (16) ----*/
+#define BITS_EXT_SYNC_NONE          0x00
+#define BITS_EXT_SYNC_TEMP          0x20
+#define BITS_EXT_SYNC_GYROX         0x40
+#define BITS_EXT_SYNC_GYROY         0x60
+#define BITS_EXT_SYNC_GYROZ         0x80
+#define BITS_EXT_SYNC_ACCELX        0xA0
+#define BITS_EXT_SYNC_ACCELY        0xC0
+#define BITS_EXT_SYNC_ACCELZ        0xE0
+#define BITS_EXT_SYNC_MASK          0xE0
+#define BITS_FS_250DPS              0x00
+#define BITS_FS_500DPS              0x08
+#define BITS_FS_1000DPS             0x10
+#define BITS_FS_2000DPS             0x18
+#define BITS_FS_MASK                0x18
+#define BITS_DLPF_CFG_256HZ_NOLPF2  0x00
+#define BITS_DLPF_CFG_188HZ         0x01
+#define BITS_DLPF_CFG_98HZ          0x02
+#define BITS_DLPF_CFG_42HZ          0x03
+#define BITS_DLPF_CFG_20HZ          0x04
+#define BITS_DLPF_CFG_10HZ          0x05
+#define BITS_DLPF_CFG_5HZ           0x06
+#define BITS_DLPF_CFG_2100HZ_NOLPF  0x07
+#define BITS_DLPF_CFG_MASK          0x07
+/*---- MPU 'INT_CFG' register (17) ----*/
+#define BIT_ACTL                    0x80
+#define BIT_ACTL_LOW                0x80
+#define BIT_ACTL_HIGH               0x00
+#define BIT_OPEN                    0x40
+#define BIT_OPEN_DRAIN              0x40
+#define BIT_PUSH_PULL               0x00
+#define BIT_LATCH_INT_EN            0x20
+#define BIT_INT_PULSE_WIDTH_50US    0x00
+#define BIT_INT_ANYRD_2CLEAR        0x10
+#define BIT_INT_STAT_READ_2CLEAR    0x00
+#define BIT_MPU_RDY_EN              0x04
+#define BIT_DMP_INT_EN              0x02
+#define BIT_RAW_RDY_EN              0x01
+/*---- MPU 'INT_STATUS' register (1A) ----*/
+#define BIT_INT_STATUS_FIFO_OVERLOW 0x80
+#define BIT_MPU_RDY                 0x04
+#define BIT_DMP_INT                 0x02
+#define BIT_RAW_RDY                 0x01
+/*---- MPU 'BANK_SEL' register (37) ----*/
+#define BIT_PRFTCH_EN               0x20
+#define BIT_CFG_USER_BANK           0x10
+#define BITS_MEM_SEL                0x0f
+/*---- MPU 'USER_CTRL' register (3D) ----*/
+#define BIT_DMP_EN                  0x80
+#define BIT_FIFO_EN                 0x40
+#define BIT_AUX_IF_EN               0x20
+#define BIT_AUX_RD_LENG             0x10
+#define BIT_AUX_IF_RST              0x08
+#define BIT_DMP_RST                 0x04
+#define BIT_FIFO_RST                0x02
+#define BIT_GYRO_RST                0x01
+/*---- MPU 'PWR_MGM' register (3E) ----*/
+#define BIT_H_RESET                 0x80
+#define BIT_SLEEP                   0x40
+#define BIT_STBY_XG                 0x20
+#define BIT_STBY_YG                 0x10
+#define BIT_STBY_ZG                 0x08
+#define BITS_CLKSEL                 0x07
+
+/*---- MPU Silicon Revision ----*/
+#define MPU_SILICON_REV_A4           1	/* MPU A4 Device */
+#define MPU_SILICON_REV_B1           2	/* MPU B1 Device */
+#define MPU_SILICON_REV_B4           3	/* MPU B4 Device */
+#define MPU_SILICON_REV_B6           4	/* MPU B6 Device */
+
+/*---- MPU Memory ----*/
+#define MPU_MEM_BANK_SIZE           (256)
+#define FIFO_HW_SIZE                (512)
+
+enum MPU_MEMORY_BANKS {
+	MPU_MEM_RAM_BANK_0 = 0,
+	MPU_MEM_RAM_BANK_1,
+	MPU_MEM_RAM_BANK_2,
+	MPU_MEM_RAM_BANK_3,
+	MPU_MEM_NUM_RAM_BANKS,
+	MPU_MEM_OTP_BANK_0 = MPU_MEM_NUM_RAM_BANKS,
+	/* This one is always last */
+	MPU_MEM_NUM_BANKS
+};
+
+/*---- structure containing control variables used by MLDL ----*/
+/*---- MPU clock source settings ----*/
+/*---- MPU filter selections ----*/
+enum mpu_filter {
+	MPU_FILTER_256HZ_NOLPF2 = 0,
+	MPU_FILTER_188HZ,
+	MPU_FILTER_98HZ,
+	MPU_FILTER_42HZ,
+	MPU_FILTER_20HZ,
+	MPU_FILTER_10HZ,
+	MPU_FILTER_5HZ,
+	MPU_FILTER_2100HZ_NOLPF,
+	NUM_MPU_FILTER
+};
+
+enum mpu_fullscale {
+	MPU_FS_250DPS = 0,
+	MPU_FS_500DPS,
+	MPU_FS_1000DPS,
+	MPU_FS_2000DPS,
+	NUM_MPU_FS
+};
+
+enum mpu_clock_sel {
+	MPU_CLK_SEL_INTERNAL = 0,
+	MPU_CLK_SEL_PLLGYROX,
+	MPU_CLK_SEL_PLLGYROY,
+	MPU_CLK_SEL_PLLGYROZ,
+	MPU_CLK_SEL_PLLEXT32K,
+	MPU_CLK_SEL_PLLEXT19M,
+	MPU_CLK_SEL_RESERVED,
+	MPU_CLK_SEL_STOP,
+	NUM_CLK_SEL
+};
+
+enum mpu_ext_sync {
+	MPU_EXT_SYNC_NONE = 0,
+	MPU_EXT_SYNC_TEMP,
+	MPU_EXT_SYNC_GYROX,
+	MPU_EXT_SYNC_GYROY,
+	MPU_EXT_SYNC_GYROZ,
+	MPU_EXT_SYNC_ACCELX,
+	MPU_EXT_SYNC_ACCELY,
+	MPU_EXT_SYNC_ACCELZ,
+	NUM_MPU_EXT_SYNC
+};
+
+#define DLPF_FS_SYNC_VALUE(ext_sync, full_scale, lpf) \
+	((ext_sync << 5) | (full_scale << 3) | lpf)
+
+#endif				/* __MPU3050_H_ */
-- 
1.7.4.1

