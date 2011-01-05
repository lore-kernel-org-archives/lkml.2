Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1AEAqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:46:02 -0500
Received: from ns2.cypress.com ([157.95.67.5]:47872 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1AEAqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:46:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
Date: Tue, 4 Jan 2011 16:45:25 -0800
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09014002D8@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
Thread-Index: AcunjQ7BIvsaxHgNR7GfRD6YRAOqLAAV1HPQASMvI6A=
References: <Kevin McNeely <kev@cypress.com> <1293650268-1561-1-git-send-email-kev@cypress.com> <76153435f70afe6c418eee6b7457be92@mail.gmail.com>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Shubhrajyoti Datta" <shubhrajyoti@ti.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Henrik Rydberg" <rydberg@euromail.se>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Alan Cox" <alan@linux.intel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Jan 2011 00:45:38.0708 (UTC) FILETIME=[DF416D40:01CBAC71]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shubhrajyoti,

I have response comments in line with your comments.

Thank you,
Kevin


> -----Original Message-----
> From: Shubhrajyoti Datta [mailto:shubhrajyoti@ti.com]
> Sent: Wednesday, December 29, 2010 10:05 PM
> To: Kevin McNeely; Dmitry Torokhov
> Cc: David Brown; Trilok Soni; Henrik Rydberg; Samuel Ortiz; Eric Miao;
> Mike Frysinger; Alan Cox; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core
> Driver
> 
> Hi Kevin,
> Some minor comments.
> 
> > -----Original Message-----
> > From: linux-input-owner@vger.kernel.org [mailto:linux-input-
> > owner@vger.kernel.org] On Behalf Of Kevin McNeely
> > Sent: Thursday, December 30, 2010 12:48 AM
> > To: Dmitry Torokhov
> > Cc: David Brown; Trilok Soni; Kevin McNeely; Dmitry Torokhov; Henrik
> > Rydberg; Samuel Ortiz; Eric Miao; Mike Frysinger; Alan Cox; linux-
> > input@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
> >
> > Cypress TTSP Gen3 Core Driver.
> > Core Driver includes platform data definition file,
> > core driver definition file, and core touchscreen
> > touch handling of device data. Generates
> > multi-touch input events.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > ---
> > Changes since v2:
> > - Simplified Protocol A
> > - Modified pointed out driver writing style
> >
> >  drivers/input/touchscreen/Kconfig       |    5 +
> >  drivers/input/touchscreen/Makefile      |    1 +
> >  drivers/input/touchscreen/cyttsp_core.c |  808
> > +++++++++++++++++++++++++++++++
> >  drivers/input/touchscreen/cyttsp_core.h |   55 +++
> >  include/linux/input/cyttsp.h            |   68 +++
> >  5 files changed, 937 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/input/touchscreen/cyttsp_core.c
> >  create mode 100644 drivers/input/touchscreen/cyttsp_core.h
> >  create mode 100644 include/linux/input/cyttsp.h
> >
> > diff --git a/drivers/input/touchscreen/Kconfig
> > b/drivers/input/touchscreen/Kconfig
> > index 06ea8da..7d886bc 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -124,6 +124,11 @@ config TOUCHSCREEN_CY8CTMG110
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called cy8ctmg110_ts.
> >
> > +config TOUCHSCREEN_CYTTSP_CORE
> > +	bool "Cypress TTSP touchscreen core"
> > +	help
> > +	  Always activated for Cypress TTSP touchscreen
> > +
> >  config TOUCHSCREEN_DA9034
> >  	tristate "Touchscreen support for Dialog Semiconductor DA9034"
> >  	depends on PMIC_DA903X
> > diff --git a/drivers/input/touchscreen/Makefile
> > b/drivers/input/touchscreen/Makefile
> > index 7cc1b4f..b6f1ba8 100644
> > --- a/drivers/input/touchscreen/Makefile
> > +++ b/drivers/input/touchscreen/Makefile
> > @@ -16,6 +16,7 @@ obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+=
> > atmel_tsadcc.o
> >  obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
> >  obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
> > +obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)   += cyttsp_core.o
> >  obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
> >  obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
> > diff --git a/drivers/input/touchscreen/cyttsp_core.c
> > b/drivers/input/touchscreen/cyttsp_core.c
> > new file mode 100644
> > index 0000000..21a342f
> > --- /dev/null
> > +++ b/drivers/input/touchscreen/cyttsp_core.c
> > @@ -0,0 +1,808 @@
> > +/*
> > + * Core Source for:
> > + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen
> drivers.
> > + * For use with Cypress Txx3xx parts.
> > + * Supported parts include:
> > + * CY8CTST341
> > + * CY8CTMA340
> > + *
> > + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2, and only version 2, as published by the
> > + * Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
License
> > along
> > + * with this program; if not, write to the Free Software
Foundation,
> > Inc.,
> > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> <kev@cypress.com>
> > + *
> > + */
> > +
> > +#include "cyttsp_core.h"
> > +
> > +#include <linux/delay.h>
> > +#include <linux/input.h>
> > +#include <linux/gpio.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/slab.h>
> > +
> > +/* Bootloader File 0 offset */
> > +#define CY_BL_FILE0       0x00
> > +/* Bootloader command directive */
> > +#define CY_BL_CMD         0xFF
> > +/* Bootloader Exit and Verify Checksum command */
> > +#define CY_BL_EXIT        0xA5
> > +/* Bootloader number of command keys */
> > +#define CY_NUM_BL_KEYS    8
> > +/* Bootloader default command keys */
> > +#define CY_BL_KEY0 0
> > +#define CY_BL_KEY1 1
> > +#define CY_BL_KEY2 2
> > +#define CY_BL_KEY3 3
> > +#define CY_BL_KEY4 4
> > +#define CY_BL_KEY5 5
> > +#define CY_BL_KEY6 6
> > +#define CY_BL_KEY7 7
> > +
> > +/* helpers */
> > +#define GET_NUM_TOUCHES(x)          ((x) & 0x0F)
> > +#define IS_LARGE_AREA(x)            (((x) & 0x10) >> 4)
> > +#define IS_BAD_PKT(x)               ((x) & 0x20)
> > +#define IS_VALID_APP(x)             ((x) & 0x01)
> > +#define IS_OPERATIONAL_ERR(x)       ((x) & 0x3F)
> > +#define GET_HSTMODE(reg)            ((reg & 0x70) >> 4)
> > +#define GET_BOOTLOADERMODE(reg)     ((reg & 0x10) >> 4)
> > +
> > +#define CY_REG_BASE                 0x00
> > +#define CY_REG_ACT_DIST             0x1E
> > +#define CY_REG_ACT_INTRVL           0x1D
> > +#define CY_REG_TCH_TMOUT            (CY_REG_ACT_INTRVL+1)
> > +#define CY_REG_LP_INTRVL            (CY_REG_TCH_TMOUT+1)
> > +#define CY_MAXZ                     255
> > +#define CY_DELAY_DFLT               20 /* ms */
> > +#define CY_DELAY_MAX                (500/CY_DELAY_DFLT) /* half
> second
> */
> > +#define CY_ACT_DIST_DFLT            0xF8
> > +#define CY_HNDSHK_BIT               0x80
> > +/* device mode bits */
> > +#define CY_OPERATE_MODE             0x00
> > +#define CY_SYSINFO_MODE             0x10
> > +/* power mode select bits */
> > +#define CY_SOFT_RESET_MODE          0x01 /* return to Bootloader
> mode
> */
> > +#define CY_DEEP_SLEEP_MODE          0x02
> > +#define CY_LOW_POWER_MODE           0x04
> > +
> > +/* TrueTouch Standard Product Gen3 interface definition */
> > +struct cyttsp_xydata {
> > +	u8 hst_mode;
> > +	u8 tt_mode;
> > +	u8 tt_stat;
> > +	u8 tch1_xhi;
> > +	u8 tch1_xlo;
> > +	u8 tch1_yhi;
> > +	u8 tch1_ylo;
> > +	u8 tch1_z;
> > +	u8 unused;
> > +	u8 tch2_xhi;
> > +	u8 tch2_xlo;
> > +	u8 tch2_yhi;
> > +	u8 tch2_ylo;
> > +	u8 tch2_z;
> > +	u8 unused_grp[13];
> > +	u8 tt_undef[3];
> > +	u8 act_dist;
> > +	u8 tt_reserved;
> > +};
> > +
> > +/* TTSP System Information interface definition */
> > +struct cyttsp_sysinfo_data {
> > +	u8 hst_mode;
> > +	u8 mfg_cmd;
> > +	u8 mfg_stat;
> > +	u8 cid[3];
> > +	u8 tt_undef1;
> > +	u8 uid[8];
> > +	u8 bl_verh;
> > +	u8 bl_verl;
> > +	u8 tts_verh;
> > +	u8 tts_verl;
> > +	u8 app_idh;
> > +	u8 app_idl;
> > +	u8 app_verh;
> > +	u8 app_verl;
> > +	u8 tt_undef[5];
> > +	u8 scn_typ;
> > +	u8 act_intrvl;
> > +	u8 tch_tmout;
> > +	u8 lp_intrvl;
> > +};
> > +
> > +/* TTSP Bootloader Register Map interface definition */
> > +#define CY_BL_CHKSUM_OK 0x01
> > +struct cyttsp_bootloader_data {
> > +	u8 bl_file;
> > +	u8 bl_status;
> > +	u8 bl_error;
> > +	u8 blver_hi;
> > +	u8 blver_lo;
> > +	u8 bld_blver_hi;
> > +	u8 bld_blver_lo;
> > +	u8 ttspver_hi;
> > +	u8 ttspver_lo;
> > +	u8 appid_hi;
> > +	u8 appid_lo;
> > +	u8 appver_hi;
> > +	u8 appver_lo;
> > +	u8 cid_0;
> > +	u8 cid_1;
> > +	u8 cid_2;
> > +};
> > +
> > +struct cyttsp_tch {
> > +	u16 x;
> > +	u16 y;
> > +	u8 z;
> > +};
> > +
> > +struct cyttsp {
> > +	struct device *dev;
> > +	int irq;
> > +	struct input_dev *input;
> > +	struct mutex mutex;
> > +	char phys[32];
> > +	const struct bus_type *bus_type;
> > +	const struct cyttsp_platform_data *platform_data;
> > +	struct cyttsp_bus_ops *bus_ops;
> > +	struct cyttsp_xydata xy_data;
> > +	struct cyttsp_bootloader_data bl_data;
> > +	struct cyttsp_sysinfo_data sysinfo_data;
> > +	struct completion bl_ready;
> > +	enum cyttsp_powerstate power_state;
> > +};
> > +
> > +static const u8 bl_command[] = {
> > +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> > +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> > +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> > +	CY_BL_KEY6, CY_BL_KEY7
> > +};
> > +
> > +static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
> > +	u8 length, void *buf)
> > +{
> > +	int retval;
> > +	int tries;
> > +
> > +	if (!buf || !length)
> > +		return -EIO;
> > +
> > +	for (tries = 0, retval = -1;
> > +		tries < CY_NUM_RETRY && (retval < 0);
> > +		tries++)
> > +		retval = ts->bus_ops->read(ts->bus_ops, command, length,
> buf);
> > +
> > +	return retval;
> > +}
> > +
> > +static int ttsp_write_block_data(struct cyttsp *ts, u8 command,
> > +	u8 length, void *buf)
> > +{
> > +	int retval;
> > +	if (!buf || !length)
> > +		return -EIO;
> > +
> > +	retval = ts->bus_ops->write(ts->bus_ops, command, length, buf);
> > +
> > +	return retval;
> > +}
> > +
> > +static int ttsp_tch_ext(struct cyttsp *ts, void *buf)
> > +{
> > +	int retval;
> > +
> > +	if (!buf)
> > +		return -EIO;
> > +
> > +	retval = ts->bus_ops->ext(ts->bus_ops, buf);
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_load_bl_regs(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +
> > +	memset(&(ts->bl_data), 0, sizeof(struct
cyttsp_bootloader_data));
> > +
> > +	retval =  ttsp_read_block_data(ts, CY_REG_BASE,
> > +		sizeof(ts->bl_data), &(ts->bl_data));
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_bl_app_valid(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +
> > +	retval = cyttsp_load_bl_regs(ts);
> > +
> > +	if (retval < 0)
> > +		return -ENODEV;
> > +
> > +	if (GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
> > +		if (IS_VALID_APP(ts->bl_data.bl_status)) {
> > +			dev_dbg(ts->dev, "%s: App found; normal boot\n",
> > +				__func__);
> > +			return 0;
> > +		} else {
> > +			dev_dbg(ts->dev, "%s: NO APP; load
firmware!!\n",
> > +				__func__);
> > +			return -ENODEV;
> > +		}
> > +	} else if (GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE)
{
> > +		if (!(IS_OPERATIONAL_ERR(ts->bl_data.bl_status))) {
> > +			dev_dbg(ts->dev, "%s: Operational\n",
> > +				__func__);
> > +			return 1;
> > +		} else {
> > +			dev_dbg(ts->dev, "%s: Operational failure\n",
> > +				__func__);
> > +			return -ENODEV;
> > +		}
> > +	} else {
> > +		dev_dbg(ts->dev, "%s: Non-Operational failure\n",
> > +			__func__);
> > +			return -ENODEV;
> > +	}
> > +
> > +}
> > +
> > +static int cyttsp_exit_bl_mode(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	int tries;
> > +	u8 bl_cmd[sizeof(bl_command)];
> > +
> > +	memcpy(bl_cmd, bl_command, sizeof(bl_command));
> > +	if (ts->platform_data->bl_keys)
> > +		memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
> > +			ts->platform_data->bl_keys, sizeof(bl_command));
> > +
> > +	dev_dbg(ts->dev,
> > +		"%s: bl_cmd= "
> > +		"%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X
> %02X\n",
> > +		__func__, bl_cmd[0], bl_cmd[1], bl_cmd[2],
> > +		bl_cmd[3], bl_cmd[4], bl_cmd[5], bl_cmd[6],
> > +		bl_cmd[7], bl_cmd[8], bl_cmd[9], bl_cmd[10]);
> > +
> > +	retval = ttsp_write_block_data(ts, CY_REG_BASE,
> > +		sizeof(bl_cmd), (void *)bl_cmd);
> > +	if (retval < 0)
> > +		return retval;
> > +
> > +	/* wait for TTSP Device to complete switch to Operational mode
*/
> > +	tries = 0;
> > +	do {
> > +		msleep(CY_DELAY_DFLT);
> > +		retval = cyttsp_load_bl_regs(ts);
> > +	} while (!((retval == 0) &&
> > +		!GET_BOOTLOADERMODE(ts->bl_data.bl_status)) &&
> > +		(tries++ < CY_DELAY_MAX));
> > +
> > +	dev_dbg(ts->dev, "%s: check bl ready tries=%d ret=%d
> stat=%02X\n",
> > +		__func__, tries, retval, ts->bl_data.bl_status);
> > +
> > +	if (retval < 0)
> > +		return retval;
> > +	else if (GET_BOOTLOADERMODE(ts->bl_data.bl_status))
> > +		return -ENODEV;
> > +	else
> > +		return 0;
> > +}
> > +
> > +static int cyttsp_set_operational_mode(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	int tries;
> > +	u8 cmd = CY_OPERATE_MODE;
> > +
> > +	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd),
> &cmd);
> > +
> > +	if (retval < 0)
> > +		return retval;
> > +
> > +	/* wait for TTSP Device to complete switch to Operational mode
*/
> > +	tries = 0;
> > +	do {
> > +		msleep(CY_DELAY_DFLT);
> > +		retval = ttsp_read_block_data(ts, CY_REG_BASE,
> > +			sizeof(ts->xy_data), &(ts->xy_data));
> > +	} while (!((retval == 0) &&
> > +		(ts->xy_data.act_dist == CY_ACT_DIST_DFLT)) &&
> > +		(tries++ < CY_DELAY_MAX));
> > +
> > +	dev_dbg(ts->dev, "%s: check op ready tries=%d ret=%d
> dist=%02X\n",
> > +		__func__, tries, retval, ts->xy_data.act_dist);
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	int tries;
> > +	u8 cmd = CY_SYSINFO_MODE;
> > +
> > +	memset(&(ts->sysinfo_data), 0, sizeof(struct
> cyttsp_sysinfo_data));
> > +
> > +	/* switch to sysinfo mode */
> > +	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd),
> &cmd);
> > +	if (retval < 0)
> > +		return retval;
> > +
> > +	/* read sysinfo registers */
> > +	tries = 0;
> > +	do {
> > +		msleep(CY_DELAY_DFLT);
> > +		retval = ttsp_read_block_data(ts, CY_REG_BASE,
> > +			sizeof(ts->sysinfo_data), &(ts->sysinfo_data));
> > +	} while (!((retval == 0) &&
> > +		!((ts->sysinfo_data.tts_verh == 0) &&
> > +		(ts->sysinfo_data.tts_verl == 0))) &&
> > +		(tries++ < CY_DELAY_MAX));
> > +
> > +	dev_dbg(ts->dev, "%s: check sysinfo ready tries=%d ret=%d\n",
> > +		__func__, tries, retval);
> > +
> > +	dev_info(ts->dev, "%s: tv=%02X%02X ai=0x%02X%02X "
> > +		"av=0x%02X%02X ci=0x%02X%02X%02X\n", "cyttsp",
> > +		ts->sysinfo_data.tts_verh, ts->sysinfo_data.tts_verl,
> > +		ts->sysinfo_data.app_idh, ts->sysinfo_data.app_idl,
> > +		ts->sysinfo_data.app_verh, ts->sysinfo_data.app_verl,
> > +		ts->sysinfo_data.cid[0], ts->sysinfo_data.cid[1],
> > +		ts->sysinfo_data.cid[2]);
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_set_sysinfo_regs(struct cyttsp *ts)
> > +{
> > +	int retval = 0;
> > +
> > +	if (ts->platform_data->act_intrvl != CY_ACT_INTRVL_DFLT ||
> > +		ts->platform_data->tch_tmout != CY_TCH_TMOUT_DFLT ||
> > +		ts->platform_data->lp_intrvl != CY_LP_INTRVL_DFLT) {
> > +
> > +		u8 intrvl_ray[3];
> > +
> > +		intrvl_ray[0] = ts->platform_data->act_intrvl;
> > +		intrvl_ray[1] = ts->platform_data->tch_tmout;
> > +		intrvl_ray[2] = ts->platform_data->lp_intrvl;
> > +
> > +		/* set intrvl registers */
> > +		retval = ttsp_write_block_data(ts,
> > +				CY_REG_ACT_INTRVL,
> > +				sizeof(intrvl_ray), intrvl_ray);
> > +
> > +		msleep(CY_DELAY_DFLT);
> > +	}
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_soft_reset(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	u8 cmd = CY_SOFT_RESET_MODE;
> > +
> > +	retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd),
> &cmd);
> > +	if (retval < 0)
> > +		return retval;
> > +
> > +	/* wait for interrupt to set ready completion */
> > +	INIT_COMPLETION(ts->bl_ready);
> > +
> > +	retval =
wait_for_completion_interruptible_timeout(&ts->bl_ready,
> > +		msecs_to_jiffies(CY_DELAY_DFLT * CY_DELAY_MAX));
> > +
> > +	if (retval > 0)
> > +		retval = 0;
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_act_dist_setup(struct cyttsp *ts)
> > +{
> > +	int retval;
> > +	u8 act_dist_setup;
> > +
> > +	/* Init gesture; active distance setup */
> > +	act_dist_setup = ts->platform_data->act_dist;
> > +	retval = ttsp_write_block_data(ts, CY_REG_ACT_DIST,
> > +		sizeof(act_dist_setup), &act_dist_setup);
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_hndshk(struct cyttsp *ts, u8 hst_mode)
> > +{
> > +	int retval;
> > +	u8 cmd;
> > +
> > +	cmd = hst_mode & CY_HNDSHK_BIT ?
> > +		hst_mode & ~CY_HNDSHK_BIT :
> > +		hst_mode | CY_HNDSHK_BIT;
> > +
> > +	retval = ttsp_write_block_data(ts, CY_REG_BASE,
> > +		sizeof(cmd), (u8 *)&cmd);
> > +
> > +	return retval;
> > +}
> > +
> > +/* process current touches */
> > +static int cyttsp_xy_worker(struct cyttsp *ts)
> > +{
> > +	u8 num_cur_tch = 0;
> > +	u16 x;
> > +	u16 y;
> > +	u8 z;
> > +
> > +	/* Get touch data from CYTTSP device */
> > +	if (ttsp_read_block_data(ts,
> > +		CY_REG_BASE, sizeof(struct cyttsp_xydata),
&ts->xy_data))
> > +		return 0;
> > +
> > +	/* touch extension handling */
> > +	if (ttsp_tch_ext(ts, &ts->xy_data))
> > +		return 0;
> > +
> > +	/* provide flow control handshake */
> > +	if (ts->platform_data->use_hndshk)
> > +		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
> > +			return 0;
> > +
> > +	/* determine number of currently active touches */
> > +	num_cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
> > +
> > +	/* check for any error conditions */
> > +	if (ts->power_state == CY_IDLE_STATE)
> > +		return 0;
> > +	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
> > +		return -1;
> > +	} else if (IS_LARGE_AREA(ts->xy_data.tt_stat) == 1) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Large area detected\n", __func__);
> > +	} else if (num_cur_tch > 2) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Num touch error detected\n",
> __func__);
> > +	} else if (IS_BAD_PKT(ts->xy_data.tt_mode)) {
> > +		/* terminate all active tracks */
> > +		num_cur_tch = 0;
> > +		dev_dbg(ts->dev, "%s: Invalid buffer detected\n",
> __func__);
> > +	}
> > +
> > +	/* send touches */
> > +	if (!num_cur_tch)
> > +		/* terminate previous active touch */
> > +		input_mt_sync(ts->input);
> > +
> > +	if (num_cur_tch) {
> > +		/* send touch 1 */
> > +		/*
> > +		 * If there is only one current active touch,
> > +		 * it will be reported in the touch 1 regardless
> > +		 * if it was reported in the touch 2 previously
> > +		 */
> > +		x = (ts->xy_data.tch1_xhi << 8) + ts->xy_data.tch1_xlo;
> > +		y = (ts->xy_data.tch1_yhi << 8) + ts->xy_data.tch1_ylo;
> > +		z = ts->xy_data.tch1_z;
> > +		input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> > +		input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> > +		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, z);
> > +		input_mt_sync(ts->input);
> > +	}
> > +
> > +	if (num_cur_tch > 1) {
> > +		/* send touch 2 */
> > +		x = (ts->xy_data.tch2_xhi << 8) + ts->xy_data.tch2_xlo;
> > +		y = (ts->xy_data.tch2_yhi << 8) + ts->xy_data.tch2_ylo;
> > +		z = ts->xy_data.tch2_z;
> > +		input_report_abs(ts->input, ABS_MT_POSITION_X, x);
> > +		input_report_abs(ts->input, ABS_MT_POSITION_Y, y);
> > +		input_report_abs(ts->input, ABS_MT_TOUCH_MAJOR, z);
> > +		input_mt_sync(ts->input);
> > +	}
> > +
> > +	input_sync(ts->input);
> > +
> > +	return 0;
> > +}
> > +
> > +static void cyttsp_pr_state(struct cyttsp *ts)
> > +{
> > +	static char *cyttsp_powerstate_string[] = {
> > +		"IDLE",
> > +		"ACTIVE",
> > +		"LOW_PWR",
> > +		"SLEEP",
> > +		"BOOTLOADER",
> > +		"INVALID"
> > +	};
> > +
> > +	dev_info(ts->dev, "%s: %s\n", __func__,
> > +		ts->power_state < CY_INVALID_STATE ?
> > +		cyttsp_powerstate_string[ts->power_state] :
> > +		"INVALID");
> > +}
> > +
> > +static irqreturn_t cyttsp_irq(int irq, void *handle)
> > +{
> > +	struct cyttsp *ts = handle;
> > +	int retval;
> > +
> > +	if (ts->power_state == CY_BL_STATE)
> > +		complete(&ts->bl_ready);
> > +	else {
> > +		/* process the touches */
> > +		retval = cyttsp_xy_worker(ts);
> > +
> > +		if (retval < 0) {
> > +			/*
> > +			 * TTSP device has reset back to bootloader
mode.
> > +			 * Restore to operational mode.
> > +			 */
> > +			retval = cyttsp_exit_bl_mode(ts);
> > +			if (retval)
> > +				ts->power_state = CY_IDLE_STATE;
> > +			else
> > +				ts->power_state = CY_ACTIVE_STATE;
> > +			cyttsp_pr_state(ts);
> > +		}
> > +	}
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int cyttsp_power_on(struct cyttsp *ts)
> > +{
> > +	int retval = 0;
> > +
> > +	if (!ts)
> > +		return -ENOMEM;
> > +
> > +	ts->power_state = CY_BL_STATE;
> > +
> > +	/* enable interrupts */
> > +	retval = request_threaded_irq(ts->irq, NULL, cyttsp_irq,
> > +		IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > +		ts->platform_data->name, ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	retval = cyttsp_soft_reset(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	retval = cyttsp_bl_app_valid(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +	else if (retval > 0)
> > +		goto no_bl_bypass;
> > +
> > +	retval = cyttsp_exit_bl_mode(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	ts->power_state = CY_IDLE_STATE;
> > +
> > +no_bl_bypass:
> > +	retval = cyttsp_set_sysinfo_mode(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	retval = cyttsp_set_sysinfo_regs(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	retval = cyttsp_set_operational_mode(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	/* init active distance */
> > +	retval = cyttsp_act_dist_setup(ts);
> > +	if (retval < 0)
> > +		goto bypass;
> > +
> > +	ts->power_state = CY_ACTIVE_STATE;
> > +	retval = 0;
> > +
> > +bypass:
> > +	cyttsp_pr_state(ts);
> > +	return retval;
> > +}
> > +
> > +#ifdef CONFIG_PM
> > +int cyttsp_resume(void *handle)
> > +{
> > +	struct cyttsp *ts = handle;
> > +	int retval = 0;
> > +	struct cyttsp_xydata xydata;
> > +
> > +	if (ts->platform_data->use_sleep && (ts->power_state !=
> > +		CY_ACTIVE_STATE)) {
> > +		if (ts->platform_data->wakeup) {
> > +			retval = ts->platform_data->wakeup();
> > +			if (retval < 0)
> > +				dev_dbg(ts->dev, "%s: Error, wakeup
> failed!\n",
> > +					__func__);
> > +		} else {
> > +			dev_dbg(ts->dev, "%s: Error, wakeup not
> implemented "
> > +				"(check board file).\n", __func__);
> > +			retval = -ENOSYS;
> > +		}
> > +		if (!(retval < 0)) {
> > +			retval = ttsp_read_block_data(ts, CY_REG_BASE,
> > +				sizeof(xydata), &xydata);
> > +			if (!(retval < 0) &&
> !GET_HSTMODE(xydata.hst_mode))
> > +				ts->power_state = CY_ACTIVE_STATE;
> > +		}
> > +	}
> > +	dev_dbg(ts->dev, "%s: Wake Up %s\n", __func__,
> > +		(retval < 0) ? "FAIL" : "PASS");
> > +	return retval;
> > +}
> > +EXPORT_SYMBOL_GPL(cyttsp_resume);
> > +
> > +int cyttsp_suspend(void *handle)
> > +{
> > +	struct cyttsp *ts = handle;
> > +	u8 sleep_mode = 0;
> > +	int retval = 0;
> > +
> > +	if (ts->platform_data->use_sleep &&
> > +		(ts->power_state == CY_ACTIVE_STATE)) {
> > +		sleep_mode = CY_DEEP_SLEEP_MODE;
> > +		retval = ttsp_write_block_data(ts,
> > +			CY_REG_BASE, sizeof(sleep_mode), &sleep_mode);
> > +		if (!(retval < 0))
> > +			ts->power_state = CY_SLEEP_STATE;
> > +	}
> > +	dev_dbg(ts->dev, "%s: Sleep Power state is %s\n", __func__,
> > +		(ts->power_state == CY_ACTIVE_STATE) ?
> > +		"ACTIVE" :
> > +		((ts->power_state == CY_SLEEP_STATE) ?
> > +		"SLEEP" : "LOW POWER"));
> > +	return retval;
> > +}
> > +EXPORT_SYMBOL_GPL(cyttsp_suspend);
> > +#endif
> > +
> > +static int cyttsp_open(struct input_dev *dev)
> > +{
> > +	struct cyttsp *ts = input_get_drvdata(dev);
> > +
> > +	return cyttsp_power_on(ts);
> > +}
> > +
> > +void cyttsp_core_release(void *handle)
> > +{
> > +	struct cyttsp *ts = handle;
> > +
> > +	if (ts) {
> > +		mutex_destroy(&ts->mutex);
> > +		free_irq(ts->irq, ts);
> > +		input_unregister_device(ts->input);
> > +		if (ts->platform_data->exit)
> > +			ts->platform_data->exit();
> > +		kfree(ts);
> > +	}
> > +}
> > +EXPORT_SYMBOL_GPL(cyttsp_core_release);
> > +
> > +static void cyttsp_close(struct input_dev *dev)
> > +{
> > +	struct cyttsp *ts = input_get_drvdata(dev);
> > +
> > +	free_irq(ts->irq, ts);
> > +}
> > +
> > +void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct
device
> > *dev)
> You may consider devinit as called only from probe.
> 

This is common initialization code.  The devinit probe is declared in
the I2C and SPI host communication files (patches 2/3 and 3/3).

> > +{
> > +	struct input_dev *input_device;
> > +
> > +	struct cyttsp *ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> > +
> > +	if (!ts) {
> > +		dev_dbg(ts->dev, "%s: Error, kzalloc\n", __func__);
> > +		goto error_alloc_data;
> > +	}
> > +
> > +	if (dev == NULL || bus_ops == NULL) {
> > +		kfree(ts);
> > +		goto error_alloc_data;
> > +	}
> > +
> > +	mutex_init(&ts->mutex);
> > +	ts->dev = dev;
> > +	ts->platform_data = dev->platform_data;
> > +	ts->bus_ops = bus_ops;
> > +	init_completion(&ts->bl_ready);
> > +
> > +	if (ts->platform_data->init) {
> > +		if (ts->platform_data->init()) {
> > +			dev_dbg(ts->dev, "%s: Error, platform init
> failed!\n",
> > +				__func__);
> > +			goto error_init;
> > +		}
> > +	}
> > +
> > +	ts->irq = gpio_to_irq(ts->platform_data->irq_gpio);
> > +	if (ts->irq <= 0) {
> > +		dev_dbg(ts->dev, "%s: Error, failed to allocate irq\n",
> > +			__func__);
> > +			goto error_init;
> > +	}
> > +
> > +	/* Create the input device and register it. */
> > +	input_device = input_allocate_device();
> > +	if (!input_device) {
> > +		dev_dbg(ts->dev, "%s: Error, failed to allocate input
> > device\n",
> > +			__func__);
> > +		goto error_input_allocate_device;
> > +	}
> > +
> > +	ts->input = input_device;
> > +	input_device->name = ts->platform_data->name;
> > +	snprintf(ts->phys, sizeof(ts->phys), "%s", dev_name(dev));
> > +	input_device->phys = ts->phys;
> > +	input_device->dev.parent = ts->dev;
> > +	ts->bus_type = bus_ops->dev->bus;
> > +	input_device->open = cyttsp_open;
> > +	input_device->close = cyttsp_close;
> > +	input_set_drvdata(input_device, ts);
> > +
> > +	__set_bit(EV_SYN, input_device->evbit);
> > +	__set_bit(EV_KEY, input_device->evbit);
> > +	__set_bit(EV_ABS, input_device->evbit);
> > +
> > +	input_set_abs_params(input_device, ABS_MT_POSITION_X,
> > +		0, ts->platform_data->maxx, 0, 0);
> > +	input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> > +		0, ts->platform_data->maxy, 0, 0);
> > +	input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
> > +		0, CY_MAXZ, 0, 0);
> > +
> > +	if (input_register_device(input_device)) {
> > +		dev_dbg(ts->dev, "%s: Error, failed to register input
> > device\n",
> > +			__func__);
> > +		goto error_input_register_device;
> > +	}
> > +
> > +	goto no_error;
> > +
> > +error_input_register_device:
> > +	input_unregister_device(input_device);
> > +error_input_allocate_device:
> > +	if (ts->platform_data->exit)
> > +		ts->platform_data->exit();
> > +error_init:
> > +	mutex_destroy(&ts->mutex);
> > +	kfree(ts);
> Here ts is freed however we fall back and return ts.
> 

The ts pointer is returned as NULL for error condition.  This error
condition is detected by the probe function in the I2C and SPI probes
(patch 2/3 and 3/3).

> > +error_alloc_data:
> > +no_error:
> > +	return ts;
> > +}
> > +EXPORT_SYMBOL_GPL(cyttsp_core_init);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen
driver
> > core");
> > +MODULE_AUTHOR("Cypress");
> > +
> > diff --git a/drivers/input/touchscreen/cyttsp_core.h
> > b/drivers/input/touchscreen/cyttsp_core.h
> > new file mode 100644
> > index 0000000..b6fa22a
> > --- /dev/null
> > +++ b/drivers/input/touchscreen/cyttsp_core.h
> > @@ -0,0 +1,55 @@
> > +/*
> > + * Header file for:
> > + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen
> drivers.
> > + * For use with Cypress Txx3xx parts.
> > + * Supported parts include:
> > + * CY8CTST341
> > + * CY8CTMA340
> > + *
> > + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2, and only version 2, as published by the
> > + * Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
License
> > along
> > + * with this program; if not, write to the Free Software
Foundation,
> > Inc.,
> > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> <kev@cypress.com>
> > + *
> > + */
> > +
> > +
> > +#ifndef __CYTTSP_CORE_H__
> > +#define __CYTTSP_CORE_H__
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/err.h>
> > +#include <linux/input/cyttsp.h>
> > +
> > +#define CY_NUM_RETRY                4 /* max number of retries for
> read
> > ops */
> > +
> > +
> > +struct cyttsp_bus_ops {
> > +	s32 (*write)(void *handle, u8 addr, u8 length, const void
> *values);
> > +	s32 (*read)(void *handle, u8 addr, u8 length, void *values);
> > +	s32 (*ext)(void *handle, void *values);
> > +	struct device *dev;
> > +};
> > +
> > +void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct
device
> > *dev);
> > +
> > +void cyttsp_core_release(void *handle);
> > +#ifdef CONFIG_PM
> > +int cyttsp_resume(void *handle);
> > +int cyttsp_suspend(void *handle);
> > +#endif
> > +
> > +#endif /* __CYTTSP_CORE_H__ */
> > diff --git a/include/linux/input/cyttsp.h
> b/include/linux/input/cyttsp.h
> > new file mode 100644
> > index 0000000..c3959ce
> > --- /dev/null
> > +++ b/include/linux/input/cyttsp.h
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Header file for:
> > + * Cypress TrueTouch(TM) Standard Product (TTSP) touchscreen
> drivers.
> > + * For use with Cypress Txx3xx parts.
> > + * Supported parts include:
> > + * CY8CTST341
> > + * CY8CTMA340
> > + *
> > + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2, and only version 2, as published by the
> > + * Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
License
> > along
> > + * with this program; if not, write to the Free Software
Foundation,
> > Inc.,
> > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> (kev@cypress.com)
> > + *
> > + */
> > +#ifndef _CYTTSP_H_
> > +#define _CYTTSP_H_
> > +
> > +#define CY_SPI_NAME "cyttsp-spi"
> > +#define CY_I2C_NAME "cyttsp-i2c"
> > +/* Active Power state scanning/processing refresh interval */
> > +#define CY_ACT_INTRVL_DFLT 0x00 /* ms */
> > +/* touch timeout for the Active power */
> > +#define CY_TCH_TMOUT_DFLT 0xFF /* ms */
> > +/* Low Power state scanning/processing refresh interval */
> > +#define CY_LP_INTRVL_DFLT 0x0A /* ms */
> > +/* Active distance in pixels for a gesture to be reported */
> > +#define CY_ACT_DIST_DFLT 0xF8 /* pixels */
> > +
> > +enum cyttsp_powerstate {
> > +	CY_IDLE_STATE,
> > +	CY_ACTIVE_STATE,
> > +	CY_LOW_PWR_STATE,
> > +	CY_SLEEP_STATE,
> > +	CY_BL_STATE,
> > +	CY_INVALID_STATE	/* always last in the list */
> > +};
> > +
> > +struct cyttsp_platform_data {
> > +	u32 maxx;
> > +	u32 maxy;
> > +	bool use_hndshk;
> > +	bool use_sleep;
> > +	u8 act_dist;	/* Active distance */
> > +	u8 act_intrvl;  /* Active refresh interval; ms */
> > +	u8 tch_tmout;   /* Active touch timeout; ms */
> > +	u8 lp_intrvl;   /* Low power refresh interval; ms */
> > +	int (*wakeup)(void);
> > +	int (*init)(void);
> > +	void (*exit)(void);
> > +	char *name;
> > +	s16 irq_gpio;
> > +	u8 *bl_keys;
> > +};
> > +
> > +#endif /* _CYTTSP_H_ */
> > --
> > 1.7.2.1
> >
> >
> > ---------------------------------------------------------------
> > This message and any attachments may contain Cypress (or its
> > subsidiaries) confidential information. If it has been received
> > in error, please advise the sender and immediately delete this
> > message.
> > ---------------------------------------------------------------
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> input"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

