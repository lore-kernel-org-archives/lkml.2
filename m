Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0HDRaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:30:10 -0400
Received: from ns1.cypress.com ([157.95.67.4]:41662 "EHLO ns1.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0HDRaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:30:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Date: Wed, 4 Aug 2010 10:22:21 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C4817E@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Thread-Index: AcsiXXRJg4bhOpluT1meAgULVsHGxQRlh6wQ
References: <Kevin McNeely <kev@cypress.com> <1278968210-6827-1-git-send-email-kev@cypress.com> <4C3C1654.9010204@codeaurora.org>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Trilok Soni" <tsoni@codeaurora.org>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Fred" <fwk@ubuntu.linuxcertified.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Arnaud Patard" <arnaud.patard@rtp-net.org>,
        "Antonio Ospite" <ospite@studenti.unina.it>,
        "Henrik Rydberg" <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <khali@linux-fr.org>, <linux-arm-msm@vger.kernel.org>
X-OriginalArrivalTime: 04 Aug 2010 17:22:22.0998 (UTC) FILETIME=[99C66360:01CB33F9]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trilok,

> -----Original Message-----
> From: Trilok Soni [mailto:tsoni@codeaurora.org]
> Sent: Tuesday, July 13, 2010 12:32 AM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Fred; Samuel Ortiz; Eric Miao; Mark
> Brown; Simtec Linux Team; Arnaud Patard; Antonio Ospite; Henrik
> Rydberg; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-i2c@vger.kernel.org; khali@linux-fr.org; linux-arm-
> msm@vger.kernel.org
> Subject: Re: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
> 
> Hi Kevin,
> 
> Thanks for posting this driver.
> 
> Adding Jean Delvar for i2c bits.
> 
> On 7/13/2010 2:26 AM, Kevin McNeely wrote:
> > From: Fred <fwk@ubuntu.linuxcertified.com>
> 
> E-mail id looks wrong. Do you mean fwk@cypress.com?
> 
> >
> > This is a new touchscreen driver for the Cypress Semiconductor
> > cyttsp family of devices.  This driver is for the i2c version
> > of cyttsp parts.
> 
> Please explain in commit text which exact version of the chips this
> driver is supporting.
> It is hard to make out that from this text.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > ---
> >  drivers/input/touchscreen/Kconfig      |   13 +
> >  drivers/input/touchscreen/Makefile     |    1 +
> >  drivers/input/touchscreen/cyttsp-i2c.c | 2016
> ++++++++++++++++++++++++++++++++
> >  include/linux/cyttsp.h                 |  649 ++++++++++
> 
> Please move this file to include/linux/input directory.
> 
> 
> >
> > diff --git a/drivers/input/touchscreen/Kconfig
> b/drivers/input/touchscreen/Kconfig
> > index 3b9d5e2..a7a69a0 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -603,4 +603,17 @@ config TOUCHSCREEN_TPS6507X
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called tps6507x_ts.
> >
> > +config TOUCHSCREEN_CYTTSP_I2C
> > +	default n
> 
> Do we need to provide this if it is no by default?
> 

The new refactored code has new core file added to build dependencies.

> > +	tristate "Cypress TTSP i2c touchscreen"
> > +	depends on I2C
> > +	help
> > +	  Say Y here if you have a Cypress TTSP touchscreen
> > +	  connected to your system's i2c bus.
> 
> What is TTSP?
> 

TTSP=TrueTouch Standard Product.  Headers will be updated to show this.

> > +
> > +	  If unsure, say N.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called cyttsp_i2c.
> > +
> >  endif
> 
> 
> > diff --git a/drivers/input/touchscreen/cyttsp-i2c.c
> b/drivers/input/touchscreen/cyttsp-i2c.c
> > new file mode 100644
> > index 0000000..8397aa1
> > --- /dev/null
> > +++ b/drivers/input/touchscreen/cyttsp-i2c.c
> > @@ -0,0 +1,2016 @@
> > +/* Source for:
> > + * Cypress TrueTouch(TM) Standard Product I2C touchscreen driver.
> > + * drivers/input/touchscreen/cyttsp-i2c.c
> 
> No file paths please. Already commented on it by Christoph.
> 

Paths and filenames will be removed from headers.

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
> along
> > + * with this program; if not, write to the Free Software
Foundation,
> Inc.,
> > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > + *
> > + * Cypress reserves the right to make changes without further
notice
> > + * to the materials described herein. Cypress does not assume any
> > + * liability arising out of the application described herein.
> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> 
> I would like Dmitry to comment on it. Dmitry?
> 

The paragraph will be removed from headers.

> > + *
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/input.h>
> > +#include <linux/slab.h>
> > +#include <linux/gpio.h>
> > +#include <linux/irq.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/timer.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/byteorder/generic.h>
> > +#include <linux/bitops.h>
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +#include <linux/earlysuspend.h>
> > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> 
> We don't have early suspend support yet into the mainline kernel.
> Please remove this code from the driver.
> 

Early suspend will be removed from the driver.

> > +
> > +#define CY_DECLARE_GLOBALS
> 
> Could you please explain what it does?
> 

This has been removed.  No globals will be used.

> > +
> > +#include <linux/cyttsp.h>
> > +
> > +uint32_t cyttsp_tsdebug1 = 0xff;
> > +module_param_named(tsdebug1, cyttsp_tsdebug1, uint, 0664);
> > +
> > +/* CY TTSP I2C Driver private data */
> > +struct cyttsp {
> > +	struct i2c_client *client;
> > +	struct input_dev *input;
> > +	struct work_struct work;
> > +	struct timer_list timer;
> > +	struct mutex mutex;
> > +	char phys[32];
> > +	struct cyttsp_platform_data *platform_data;
> > +	u8 num_prv_st_tch;
> > +	u16 act_trk[CY_NUM_TRK_ID];
> > +	u16 prv_st_tch[CY_NUM_ST_TCH_ID];
> > +	u16 prv_mt_tch[CY_NUM_MT_TCH_ID];
> > +	u16 prv_mt_pos[CY_NUM_TRK_ID][2];
> > +	atomic_t irq_enabled;
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +	struct early_suspend early_suspend;
> > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> > +};
> > +static u8 irq_cnt;		/* comparison counter with register
valuw
> */
> 
> s/valuw/value
> 
> > +static u32 irq_cnt_total;	/* total interrupts */
> > +static u32 irq_err_cnt;		/* count number of touch
interrupts
> with err */
> > +#define CY_IRQ_CNT_MASK	0x000000FF	/* mapped for sizeof
count in
> reg */
> > +#define CY_IRQ_CNT_REG	0x00		/* tt_undef[0]=reg 0x1B
-
> Gen3 only */
> > +
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +static void cyttsp_early_suspend(struct early_suspend *handler);
> > +static void cyttsp_late_resume(struct early_suspend *handler);
> > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> > +
> > +static struct workqueue_struct *cyttsp_ts_wq;
> 
> Why there are so many global variables lying around?
> 

Globals have been removed.

> > +
> > +
> > +/*
>
***********************************************************************
> *****
> > + * Prototypes for static functions
> > + *
>
***********************************************************************
> *** */
> > +static void cyttsp_xy_worker(struct work_struct *work);
> > +static irqreturn_t cyttsp_irq(int irq, void *handle);
> > +static int cyttsp_inlist(u16 prev_track[],
> > +			u8 cur_trk_id, u8 *prev_loc, u8 num_touches);
> > +static int cyttsp_next_avail_inlist(u16 cur_trk[],
> > +			u8 *new_loc, u8 num_touches);
> > +static int cyttsp_putbl(struct cyttsp *ts, int show,
> > +			int show_status, int show_version, int
show_cid);
> > +static int __devinit cyttsp_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id);
> > +static int __devexit cyttsp_remove(struct i2c_client *client);
> > +static int cyttsp_resume(struct i2c_client *client);
> > +static int cyttsp_suspend(struct i2c_client *client, pm_message_t
> message);
> 
> Please re-order the functions in the driver such a way so that you
> don't need have these prototypes here.
> 

Functions have been reordered to eliminate prototypes.

> > +
> > +/* Static variables */
> > +static struct cyttsp_gen3_xydata_t g_xy_data;
> > +static struct cyttsp_bootloader_data_t g_bl_data;
> > +static struct cyttsp_sysinfo_data_t g_sysinfo_data;
> 
> again globals?
> 
> > +static const struct i2c_device_id cyttsp_id[] = {
> > +	{ CY_I2C_NAME, 0 },  { }
> 
> Why dont you put ,{} at the next line.
> 
> > +};
> 
> You should not put driver name above, but it should be something like
> real chip name.
> 
> Say cy8ctXXX.

The parts are called TTSP parts.
The driver supports all TTSP parts.
Sample part numbers will be added to the headers.

> 
> > +static u8 bl_cmd[] = {
> > +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> > +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> > +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> > +	CY_BL_KEY6, CY_BL_KEY7};
> 
> and what these keys does?
> 

The key must be sent to the device on bootup to move the device to
operational mode.

> > +
> > +MODULE_DEVICE_TABLE(i2c, cyttsp_id);
> 
> Why it is not with cyttsp_id above?
> 

This has been moved in the new code.

> > +
> > +static struct i2c_driver cyttsp_driver = {
> > +	.driver = {
> > +		.name = CY_I2C_NAME,
> > +		.owner = THIS_MODULE,
> > +	},
> > +	.probe = cyttsp_probe,
> > +	.remove = __devexit_p(cyttsp_remove),
> > +	.suspend = cyttsp_suspend,
> > +	.resume = cyttsp_resume,
> > +	.id_table = cyttsp_id,
> > +};
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen
> driver");
> > +MODULE_AUTHOR("Cypress");
> 
> MODULE_ALIAS?
> 

This has been added to new code.

> > +
> > +static ssize_t cyttsp_irq_status(struct device *dev,
> > +				struct device_attribute *attr, char
*buf)
> > +{
> > +	struct i2c_client *client = container_of(dev, struct i2c_client,
> dev);
> > +	struct cyttsp *ts = i2c_get_clientdata(client);
> > +	return sprintf(buf, "%u\n", atomic_read(&ts->irq_enabled));
> > +}
> > +
> > +static ssize_t cyttsp_irq_enable(struct device *dev,
> > +				struct device_attribute *attr,
> > +				const char *buf, size_t size)
> > +{
> > +	struct i2c_client *client = container_of(dev, struct i2c_client,
> dev);
> > +	struct cyttsp *ts = i2c_get_clientdata(client);
> > +	int err = 0;
> > +	unsigned long value;
> > +
> > +	if (size > 2)
> > +		return -EINVAL;
> > +
> > +	err = strict_strtoul(buf, 10, &value);
> > +	if (err != 0)
> > +		return err;
> > +
> > +	switch (value) {
> > +	case 0:
> > +		if (atomic_cmpxchg(&ts->irq_enabled, 1, 0)) {
> > +			pr_info("touch irq disabled!\n");
> > +			disable_irq_nosync(ts->client->irq);
> > +		}
> > +		err = size;
> > +		break;
> > +	case 1:
> > +		if (!atomic_cmpxchg(&ts->irq_enabled, 0, 1)) {
> > +			pr_info("touch irq enabled!\n");
> > +			enable_irq(ts->client->irq);
> > +		}
> > +		err = size;
> > +		break;
> > +	default:
> > +		pr_info("cyttsp_irq_enable failed -> irq_enabled =
%d\n",
> > +		atomic_read(&ts->irq_enabled));
> > +		err = -EINVAL;
> > +		break;
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +static DEVICE_ATTR(irq_enable, 0777, cyttsp_irq_status,
> cyttsp_irq_enable);
> 
> 
> Please explain why you are providing this sysfs entries?
> 

The sysfs entried were to support dynamic debug enables.
These have been removed.
The new code has replaced the custom debug.

> > +
> > +/* The cyttsp_xy_worker function reads the XY coordinates and sends
> them to
> > + * the input layer.  It is scheduled from the interrupt (or timer).
> > + */
> > +void cyttsp_xy_worker(struct work_struct *work)
> > +{
> > +	struct cyttsp *ts = container_of(work, struct cyttsp, work);
> > +	u8 id, tilt, rev_x, rev_y;
> > +	u8 i, loc;
> > +	u8 prv_tch;		/* number of previous touches */
> > +	u8 cur_tch;	/* number of current touches */
> > +	u16 tmp_trk[CY_NUM_MT_TCH_ID];
> > +	u16 snd_trk[CY_NUM_MT_TCH_ID];
> > +	u16 cur_trk[CY_NUM_TRK_ID];
> > +	u16 cur_st_tch[CY_NUM_ST_TCH_ID];
> > +	u16 cur_mt_tch[CY_NUM_MT_TCH_ID];
> > +	/* if NOT CY_USE_TRACKING_ID then
> > +	 * only uses CY_NUM_MT_TCH_ID positions */
> > +	u16 cur_mt_pos[CY_NUM_TRK_ID][2];
> > +	/* if NOT CY_USE_TRACKING_ID then
> > +	 * only uses CY_NUM_MT_TCH_ID positions */
> > +	u8 cur_mt_z[CY_NUM_TRK_ID];
> > +	u8 curr_tool_width;
> > +	u16 st_x1, st_y1;
> > +	u8 st_z1;
> > +	u16 st_x2, st_y2;
> > +	u8 st_z2;
> > +	s32 retval;
> > +
> > +	cyttsp_xdebug("TTSP worker start 1:\n");
> > +
> > +	/* get event data from CYTTSP device */
> > +	i = CY_NUM_RETRY;
> > +	do {
> > +		retval = i2c_smbus_read_i2c_block_data(ts->client,
> > +			CY_REG_BASE,
> > +			sizeof(struct cyttsp_gen3_xydata_t), (u8
> *)&g_xy_data);
> > +	} while ((retval < CY_OK) && --i);
> > +
> > +	if (retval < CY_OK) {
> > +		/* return immediately on
> > +		 * failure to read device on the i2c bus */
> > +		goto exit_xy_worker;
> > +	}
> > +
> > +	cyttsp_xdebug("TTSP worker start 2:\n");
> > +
> > +	/* compare own irq counter with the device irq counter */
> > +	if (ts->client->irq) {
> > +		u8 host_reg;
> > +		u8 cur_cnt;
> > +		if (ts->platform_data->use_hndshk) {
> > +
> > +			host_reg = g_xy_data.hst_mode & CY_HNDSHK_BIT ?
> > +				g_xy_data.hst_mode & ~CY_HNDSHK_BIT :
> > +				g_xy_data.hst_mode | CY_HNDSHK_BIT;
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE, sizeof(host_reg),
&host_reg);
> > +		}
> > +		cur_cnt = g_xy_data.tt_undef[CY_IRQ_CNT_REG];
> > +		irq_cnt_total++;
> > +		irq_cnt++;
> > +		if (irq_cnt != cur_cnt) {
> > +			irq_err_cnt++;
> > +			cyttsp_debug("i_c_ER: dv=%d fw=%d hm=%02X t=%lu
> te=%lu\n", \
> > +				irq_cnt, \
> > +				cur_cnt, g_xy_data.hst_mode, \
> > +				(unsigned long)irq_cnt_total, \
> > +				(unsigned long)irq_err_cnt);
> > +		} else {
> > +			cyttsp_debug("i_c_ok: dv=%d fw=%d hm=%02X t=%lu
> te=%lu\n", \
> > +				irq_cnt, \
> > +				cur_cnt, g_xy_data.hst_mode, \
> > +				(unsigned long)irq_cnt_total, \
> > +				(unsigned long)irq_err_cnt);
> > +		}
> > +		irq_cnt = cur_cnt;
> > +	}
> > +
> > +	/* Get the current num touches and return if there are no
touches
> */
> > +	if ((GET_BOOTLOADERMODE(g_xy_data.tt_mode) == 1) ||
> > +		(GET_HSTMODE(g_xy_data.hst_mode) != CY_OK)) {
> > +		u8 host_reg, tries;
> > +		/* the TTSP device has suffered spurious reset or mode
> switch */
> > +		cyttsp_debug( \
> > +			"Spurious err opmode (tt_mode=%02X
hst_mode=%02X)\n",
> \
> > +			g_xy_data.tt_mode, g_xy_data.hst_mode);
> > +		cyttsp_debug("Reset TTSP Device; Terminating active
> tracks\n");
> > +		/* terminate all active tracks */
> > +		cur_tch = CY_NTCH;
> > +		/* reset TTSP part and take it back out of Bootloader
mode
> */
> > +		host_reg = CY_SOFT_RESET_MODE;
> > +		retval = i2c_smbus_write_i2c_block_data(ts->client,
> > +			CY_REG_BASE,
> > +			sizeof(host_reg), &host_reg);
> > +		tries = 0;
> > +		do {
> > +			mdelay(1000);
> > +
> > +			/* set arg2 to non-0 to activate */
> > +			retval = cyttsp_putbl(ts, 1, false, false,
false);
> > +		} while (!(retval < CY_OK) &&
> > +			!GET_BOOTLOADERMODE(g_bl_data.bl_status) &&
> > +			!(g_bl_data.bl_file ==
> > +			CY_OP_MODE + CY_LOW_PWR_MODE) &&
> > +			tries++ < 10);
> > +		/* switch back to operational mode */
> > +		if (GET_BOOTLOADERMODE(g_bl_data.bl_status)) {
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(bl_cmd), bl_cmd);
> > +			tries = 0;
> > +			do {
> > +				mdelay(1000);
> > +				cyttsp_putbl(ts, 1, false, false,
false);
> > +			} while (GET_BOOTLOADERMODE(g_bl_data.bl_status)
&&
> > +				tries++ < 10);
> > +		}
> > +		if (!(retval < CY_OK)) {
> > +			host_reg = CY_OP_MODE
> > +				/* + CY_LOW_PWR_MODE */;
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(host_reg), &host_reg);
> > +			/* wait for TTSP Device to complete switch to Op
mode
> */
> > +			mdelay(1000);
> > +		}
> > +		goto exit_xy_worker;
> > +	} else {
> > +		cur_tch = GET_NUM_TOUCHES(g_xy_data.tt_stat);
> > +		if (IS_LARGE_AREA(g_xy_data.tt_stat)) {
> > +			/* terminate all active tracks */
> > +			cur_tch = CY_NTCH;
> > +			cyttsp_debug("Large obj detect (tt_stat=0x%02X).
> Terminate act trks\n", \
> > +			    g_xy_data.tt_stat);
> > +		} else if (cur_tch > CY_NUM_MT_TCH_ID) {
> > +			/* if the number of fingers on the touch surface
> > +			 * is more than the maximum then
> > +			 * there will be no new track information
> > +			 * even for the original touches.
> > +			 * Therefore, terminate all active tracks.
> > +			 */
> > +			cur_tch = CY_NTCH;
> > +			cyttsp_debug("Num touch err (tt_stat=0x%02X).
> Terminate act trks\n", \
> > +			    g_xy_data.tt_stat);
> > +		}
> > +	}
> > +
> > +	/* set tool size */
> > +	curr_tool_width = CY_SMALL_TOOL_WIDTH;
> > +
> > +	/* translate Gen2 interface data into comparable Gen3 data */
> > +	if (ts->platform_data->gen == CY_GEN2) {
> > +		struct cyttsp_gen2_xydata_t *pxy_gen2_data;
> > +		pxy_gen2_data = (struct cyttsp_gen2_xydata_t
> *)(&g_xy_data);
> > +
> > +		/* use test data? */
> > +		cyttsp_testdat(&g_xy_data, &tt_gen2_testray, \
> > +			sizeof(struct cyttsp_gen3_xydata_t));
> > +
> > +		if (pxy_gen2_data->evnt_idx == CY_GEN2_NOTOUCH) {
> > +			cur_tch = 0;
> > +		} else if (cur_tch == CY_GEN2_GHOST) {
> > +			cur_tch = 0;
> > +		} else if (cur_tch == CY_GEN2_2TOUCH) {
> > +			/* stuff artificial track ID1 and ID2 */
> > +			g_xy_data.touch12_id = 0x12;
> > +			g_xy_data.z1 = CY_MAXZ;
> > +			g_xy_data.z2 = CY_MAXZ;
> > +			cur_tch--;			/* 2 touches */
> > +		} else if (cur_tch == CY_GEN2_1TOUCH) {
> > +			/* stuff artificial track ID1 and ID2 */
> > +			g_xy_data.touch12_id = 0x12;
> > +			g_xy_data.z1 = CY_MAXZ;
> > +			g_xy_data.z2 = CY_NTCH;
> > +			if (pxy_gen2_data->evnt_idx == CY_GEN2_TOUCH2) {
> > +				/* push touch 2 data into touch1
> > +				 * (first finger up; second finger down)
*/
> > +				/* stuff artificial track ID1 for touch2
info
> */
> > +				g_xy_data.touch12_id = 0x20;
> > +				/* stuff touch 1 with touch 2 coordinate
data
> */
> > +				g_xy_data.x1 = g_xy_data.x2;
> > +				g_xy_data.y1 = g_xy_data.y2;
> > +			}
> > +		} else {
> > +			cur_tch = 0;
> > +		}
> > +	} else {
> > +		/* use test data? */
> > +		cyttsp_testdat(&g_xy_data, &tt_gen3_testray, \
> > +			sizeof(struct cyttsp_gen3_xydata_t));
> > +	}
> > +
> > +
> > +
> > +	/* clear current active track ID array and count previous
touches
> */
> > +	for (id = 0, prv_tch = CY_NTCH;
> > +		id < CY_NUM_TRK_ID; id++) {
> > +		cur_trk[id] = CY_NTCH;
> > +		prv_tch += ts->act_trk[id];
> > +	}
> > +
> > +	/* send no events if no previous touches and no new touches */
> > +	if ((prv_tch == CY_NTCH) &&
> > +		((cur_tch == CY_NTCH) ||
> > +		(cur_tch > CY_NUM_MT_TCH_ID))) {
> > +		goto exit_xy_worker;
> > +	}
> > +
> > +	cyttsp_debug("prev=%d  curr=%d\n", prv_tch, cur_tch);
> > +
> > +	for (id = 0; id < CY_NUM_ST_TCH_ID; id++) {
> > +		/* clear current single touches array */
> > +		cur_st_tch[id] = CY_IGNR_TCH;
> > +	}
> > +
> > +	/* clear single touch positions */
> > +	st_x1 = CY_NTCH;
> > +	st_y1 = CY_NTCH;
> > +	st_z1 = CY_NTCH;
> > +	st_x2 = CY_NTCH;
> > +	st_y2 = CY_NTCH;
> > +	st_z2 = CY_NTCH;
> > +
> > +	for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +		/* clear current multi-touches array and
> > +		 * multi-touch positions/z */
> > +		cur_mt_tch[id] = CY_IGNR_TCH;
> > +	}
> > +
> > +	if (ts->platform_data->use_trk_id) {
> > +		for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +			cur_mt_pos[id][CY_XPOS] = 0;
> > +			cur_mt_pos[id][CY_YPOS] = 0;
> > +			cur_mt_z[id] = 0;
> > +		}
> > +	} else {
> > +		for (id = 0; id < CY_NUM_TRK_ID; id++) {
> > +			cur_mt_pos[id][CY_XPOS] = 0;
> > +			cur_mt_pos[id][CY_YPOS] = 0;
> > +			cur_mt_z[id] = 0;
> > +		}
> > +	}
> > +
> > +	/* Determine if display is tilted */
> > +	if (FLIP_DATA(ts->platform_data->flags))
> > +		tilt = true;
> > +	else
> > +		tilt = false;
> > +
> > +	/* Check for switch in origin */
> > +	if (REVERSE_X(ts->platform_data->flags))
> > +		rev_x = true;
> > +	else
> > +		rev_x = false;
> > +
> > +	if (REVERSE_Y(ts->platform_data->flags))
> > +		rev_y = true;
> > +	else
> > +		rev_y = false;
> > +
> > +	if (cur_tch) {
> > +		struct cyttsp_gen2_xydata_t *pxy_gen2_data;
> > +		struct cyttsp_gen3_xydata_t *pxy_gen3_data;
> > +		switch (ts->platform_data->gen) {
> > +		case CY_GEN2: {
> > +			pxy_gen2_data =
> > +				(struct cyttsp_gen2_xydata_t
*)(&g_xy_data);
> > +			cyttsp_xdebug("TTSP Gen2 report:\n");
> > +			cyttsp_xdebug("%02X %02X %02X\n", \
> > +				pxy_gen2_data->hst_mode, \
> > +				pxy_gen2_data->tt_mode, \
> > +				pxy_gen2_data->tt_stat);
> > +			cyttsp_xdebug("%04X %04X %02X  %02X\n", \
> > +				pxy_gen2_data->x1, \
> > +				pxy_gen2_data->y1, \
> > +				pxy_gen2_data->z1, \
> > +				pxy_gen2_data->evnt_idx);
> > +			cyttsp_xdebug("%04X %04X %02X\n", \
> > +				pxy_gen2_data->x2, \
> > +				pxy_gen2_data->y2, \
> > +				pxy_gen2_data->tt_undef1);
> > +			cyttsp_xdebug("%02X %02X %02X\n", \
> > +				pxy_gen2_data->gest_cnt, \
> > +				pxy_gen2_data->gest_id, \
> > +				pxy_gen2_data->gest_set);
> > +			break;
> > +		}
> > +		case CY_GEN3:
> > +		default: {
> > +			pxy_gen3_data =
> > +				(struct cyttsp_gen3_xydata_t
*)(&g_xy_data);
> > +			cyttsp_xdebug("TTSP Gen3 report:\n");
> > +			cyttsp_xdebug("%02X %02X %02X\n", \
> > +				pxy_gen3_data->hst_mode,
> > +				pxy_gen3_data->tt_mode,
> > +				pxy_gen3_data->tt_stat);
> > +			cyttsp_xdebug("%04X %04X %02X  %02X", \
> > +				pxy_gen3_data->x1,
> > +				pxy_gen3_data->y1,
> > +				pxy_gen3_data->z1, \
> > +				pxy_gen3_data->touch12_id);
> > +			cyttsp_xdebug("%04X %04X %02X\n", \
> > +				pxy_gen3_data->x2, \
> > +				pxy_gen3_data->y2, \
> > +				pxy_gen3_data->z2);
> > +			cyttsp_xdebug("%02X %02X %02X\n", \
> > +				pxy_gen3_data->gest_cnt, \
> > +				pxy_gen3_data->gest_id, \
> > +				pxy_gen3_data->gest_set);
> > +			cyttsp_xdebug("%04X %04X %02X  %02X\n", \
> > +				pxy_gen3_data->x3, \
> > +				pxy_gen3_data->y3, \
> > +				pxy_gen3_data->z3, \
> > +				pxy_gen3_data->touch34_id);
> > +			cyttsp_xdebug("%04X %04X %02X\n", \
> > +				pxy_gen3_data->x4, \
> > +				pxy_gen3_data->y4, \
> > +				pxy_gen3_data->z4);
> > +			break;
> > +		}
> > +		}
> > +	}
> > +
> > +	/* process the touches */
> > +	switch (cur_tch) {
> > +	case 4: {
> > +		g_xy_data.x4 = be16_to_cpu(g_xy_data.x4);
> > +		g_xy_data.y4 = be16_to_cpu(g_xy_data.y4);
> > +		if (tilt)
> > +			FLIP_XY(g_xy_data.x4, g_xy_data.y4);
> > +
> > +		if (rev_x) {
> > +			g_xy_data.x4 =
> > +				INVERT_X(g_xy_data.x4,
ts->platform_data-
> >maxx);
> > +		}
> > +		if (rev_y) {
> > +			g_xy_data.y4 =
> > +				INVERT_X(g_xy_data.y4,
ts->platform_data-
> >maxy);
> > +		}
> > +		id = GET_TOUCH4_ID(g_xy_data.touch34_id);
> > +		if (ts->platform_data->use_trk_id) {
> > +			cur_mt_pos[CY_MT_TCH4_IDX][CY_XPOS] =
> > +				g_xy_data.x4;
> > +			cur_mt_pos[CY_MT_TCH4_IDX][CY_YPOS] =
> > +				g_xy_data.y4;
> > +			cur_mt_z[CY_MT_TCH4_IDX] = g_xy_data.z4;
> > +		} else {
> > +			cur_mt_pos[id][CY_XPOS] = g_xy_data.x4;
> > +			cur_mt_pos[id][CY_YPOS] = g_xy_data.y4;
> > +			cur_mt_z[id] = g_xy_data.z4;
> > +		}
> > +		cur_mt_tch[CY_MT_TCH4_IDX] = id;
> > +		cur_trk[id] = CY_TCH;
> > +		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <
> > +			CY_NUM_TRK_ID) {
> > +			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
> > +				st_x1 = g_xy_data.x4;
> > +				st_y1 = g_xy_data.y4;
> > +				st_z1 = g_xy_data.z4;
> > +				cur_st_tch[CY_ST_FNGR1_IDX] = id;
> > +			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] ==
id) {
> > +				st_x2 = g_xy_data.x4;
> > +				st_y2 = g_xy_data.y4;
> > +				st_z2 = g_xy_data.z4;
> > +				cur_st_tch[CY_ST_FNGR2_IDX] = id;
> > +			}
> > +		}
> > +		cyttsp_xdebug("4th XYZ:% 3d,% 3d,% 3d  ID:% 2d\n\n", \
> > +			g_xy_data.x4, g_xy_data.y4, g_xy_data.z4, \
> > +			(g_xy_data.touch34_id & 0x0F));
> > +		/* do not break */
> > +	}
> > +	case 3: {
> > +		g_xy_data.x3 = be16_to_cpu(g_xy_data.x3);
> > +		g_xy_data.y3 = be16_to_cpu(g_xy_data.y3);
> > +		if (tilt)
> > +			FLIP_XY(g_xy_data.x3, g_xy_data.y3);
> > +
> > +		if (rev_x) {
> > +			g_xy_data.x3 =
> > +				INVERT_X(g_xy_data.x3,
ts->platform_data-
> >maxx);
> > +		}
> > +		if (rev_y) {
> > +			g_xy_data.y3 =
> > +				INVERT_X(g_xy_data.y3,
ts->platform_data-
> >maxy);
> > +		}
> > +		id = GET_TOUCH3_ID(g_xy_data.touch34_id);
> > +		if (ts->platform_data->use_trk_id) {
> > +			cur_mt_pos[CY_MT_TCH3_IDX][CY_XPOS] =
> > +				g_xy_data.x3;
> > +			cur_mt_pos[CY_MT_TCH3_IDX][CY_YPOS] =
> > +				g_xy_data.y3;
> > +			cur_mt_z[CY_MT_TCH3_IDX] = g_xy_data.z3;
> > +		} else {
> > +			cur_mt_pos[id][CY_XPOS] = g_xy_data.x3;
> > +			cur_mt_pos[id][CY_YPOS] = g_xy_data.y3;
> > +			cur_mt_z[id] = g_xy_data.z3;
> > +		}
> > +		cur_mt_tch[CY_MT_TCH3_IDX] = id;
> > +		cur_trk[id] = CY_TCH;
> > +		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <
> > +			CY_NUM_TRK_ID) {
> > +			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
> > +				st_x1 = g_xy_data.x3;
> > +				st_y1 = g_xy_data.y3;
> > +				st_z1 = g_xy_data.z3;
> > +				cur_st_tch[CY_ST_FNGR1_IDX] = id;
> > +			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] ==
id) {
> > +				st_x2 = g_xy_data.x3;
> > +				st_y2 = g_xy_data.y3;
> > +				st_z2 = g_xy_data.z3;
> > +				cur_st_tch[CY_ST_FNGR2_IDX] = id;
> > +			}
> > +		}
> > +		cyttsp_xdebug("3rd XYZ:% 3d,% 3d,% 3d  ID:% 2d\n", \
> > +			g_xy_data.x3, g_xy_data.y3, g_xy_data.z3, \
> > +			((g_xy_data.touch34_id >> 4) & 0x0F));
> > +		/* do not break */
> > +	}
> > +	case 2: {
> > +		g_xy_data.x2 = be16_to_cpu(g_xy_data.x2);
> > +		g_xy_data.y2 = be16_to_cpu(g_xy_data.y2);
> > +		if (tilt)
> > +			FLIP_XY(g_xy_data.x2, g_xy_data.y2);
> > +
> > +		if (rev_x) {
> > +			g_xy_data.x2 =
> > +				INVERT_X(g_xy_data.x2,
ts->platform_data-
> >maxx);
> > +		}
> > +		if (rev_y) {
> > +			g_xy_data.y2 =
> > +				INVERT_X(g_xy_data.y2,
ts->platform_data-
> >maxy);
> > +		}
> > +		id = GET_TOUCH2_ID(g_xy_data.touch12_id);
> > +		if (ts->platform_data->use_trk_id) {
> > +			cur_mt_pos[CY_MT_TCH2_IDX][CY_XPOS] =
> > +				g_xy_data.x2;
> > +			cur_mt_pos[CY_MT_TCH2_IDX][CY_YPOS] =
> > +				g_xy_data.y2;
> > +			cur_mt_z[CY_MT_TCH2_IDX] = g_xy_data.z2;
> > +		} else {
> > +			cur_mt_pos[id][CY_XPOS] = g_xy_data.x2;
> > +			cur_mt_pos[id][CY_YPOS] = g_xy_data.y2;
> > +			cur_mt_z[id] = g_xy_data.z2;
> > +		}
> > +		cur_mt_tch[CY_MT_TCH2_IDX] = id;
> > +		cur_trk[id] = CY_TCH;
> > +		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <
> > +			CY_NUM_TRK_ID) {
> > +			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
> > +				st_x1 = g_xy_data.x2;
> > +				st_y1 = g_xy_data.y2;
> > +				st_z1 = g_xy_data.z2;
> > +				cur_st_tch[CY_ST_FNGR1_IDX] = id;
> > +			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] ==
id) {
> > +				st_x2 = g_xy_data.x2;
> > +				st_y2 = g_xy_data.y2;
> > +				st_z2 = g_xy_data.z2;
> > +				cur_st_tch[CY_ST_FNGR2_IDX] = id;
> > +			}
> > +		}
> > +		cyttsp_xdebug("2nd XYZ:% 3d,% 3d,% 3d  ID:% 2d\n", \
> > +			g_xy_data.x2, g_xy_data.y2, g_xy_data.z2, \
> > +			(g_xy_data.touch12_id & 0x0F));
> > +		/* do not break */
> > +	}
> > +	case 1:	{
> > +		g_xy_data.x1 = be16_to_cpu(g_xy_data.x1);
> > +		g_xy_data.y1 = be16_to_cpu(g_xy_data.y1);
> > +		if (tilt)
> > +			FLIP_XY(g_xy_data.x1, g_xy_data.y1);
> > +
> > +		if (rev_x) {
> > +			g_xy_data.x1 =
> > +				INVERT_X(g_xy_data.x1,
ts->platform_data-
> >maxx);
> > +		}
> > +		if (rev_y) {
> > +			g_xy_data.y1 =
> > +				INVERT_X(g_xy_data.y1,
ts->platform_data-
> >maxy);
> > +		}
> > +		id = GET_TOUCH1_ID(g_xy_data.touch12_id);
> > +		if (ts->platform_data->use_trk_id) {
> > +			cur_mt_pos[CY_MT_TCH1_IDX][CY_XPOS] =
> > +				g_xy_data.x1;
> > +			cur_mt_pos[CY_MT_TCH1_IDX][CY_YPOS] =
> > +				g_xy_data.y1;
> > +			cur_mt_z[CY_MT_TCH1_IDX] = g_xy_data.z1;
> > +		} else {
> > +			cur_mt_pos[id][CY_XPOS] = g_xy_data.x1;
> > +			cur_mt_pos[id][CY_YPOS] = g_xy_data.y1;
> > +			cur_mt_z[id] = g_xy_data.z1;
> > +		}
> > +		cur_mt_tch[CY_MT_TCH1_IDX] = id;
> > +		cur_trk[id] = CY_TCH;
> > +		if (ts->prv_st_tch[CY_ST_FNGR1_IDX] <
> > +			CY_NUM_TRK_ID) {
> > +			if (ts->prv_st_tch[CY_ST_FNGR1_IDX] == id) {
> > +				st_x1 = g_xy_data.x1;
> > +				st_y1 = g_xy_data.y1;
> > +				st_z1 = g_xy_data.z1;
> > +				cur_st_tch[CY_ST_FNGR1_IDX] = id;
> > +			} else if (ts->prv_st_tch[CY_ST_FNGR2_IDX] ==
id) {
> > +				st_x2 = g_xy_data.x1;
> > +				st_y2 = g_xy_data.y1;
> > +				st_z2 = g_xy_data.z1;
> > +				cur_st_tch[CY_ST_FNGR2_IDX] = id;
> > +			}
> > +		}
> > +		cyttsp_xdebug("1st XYZ:% 3d,% 3d,% 3d  ID:% 2d\n", \
> > +			g_xy_data.x1, g_xy_data.y1, g_xy_data.z1, \
> > +			((g_xy_data.touch12_id >> 4) & 0x0F));
> > +		break;
> > +	}
> > +	case 0:
> > +	default:{
> > +		break;
> > +	}
> > +	}
> > +
> > +	/* handle Single Touch signals */
> > +	if (ts->platform_data->use_st) {
> > +		cyttsp_xdebug("ST STEP 0 - ST1 ID=%d  ST2 ID=%d\n", \
> > +			cur_st_tch[CY_ST_FNGR1_IDX], \
> > +			cur_st_tch[CY_ST_FNGR2_IDX]);
> > +		if (cur_st_tch[CY_ST_FNGR1_IDX] > CY_NUM_TRK_ID) {
> > +			/* reassign finger 1 and 2 positions to new
tracks */
> > +			if (cur_tch > 0) {
> > +				/* reassign st finger1 */
> > +				if (ts->platform_data->use_trk_id) {
> > +					id = CY_MT_TCH1_IDX;
> > +					cur_st_tch[CY_ST_FNGR1_IDX] =
> cur_mt_tch[id];
> > +				} else {
> > +					id =
GET_TOUCH1_ID(g_xy_data.touch12_id);
> > +					cur_st_tch[CY_ST_FNGR1_IDX] =
id;
> > +				}
> > +				st_x1 = cur_mt_pos[id][CY_XPOS];
> > +				st_y1 = cur_mt_pos[id][CY_YPOS];
> > +				st_z1 = cur_mt_z[id];
> > +				cyttsp_xdebug("ST STEP 1 - ST1
ID=%3d\n", \
> > +					cur_st_tch[CY_ST_FNGR1_IDX]);
> > +				if ((cur_tch > 1) &&
> > +					(cur_st_tch[CY_ST_FNGR2_IDX] >
> > +					CY_NUM_TRK_ID)) {
> > +					/* reassign st finger2 */
> > +					if (cur_tch > 1) {
> > +						if
(ts->platform_data->use_trk_id)
> {
> > +							id =
CY_MT_TCH2_IDX;
> > +
cur_st_tch[CY_ST_FNGR2_IDX] =
> cur_mt_tch[id];
> > +						} else {
> > +							id =
> GET_TOUCH2_ID(g_xy_data.touch12_id);
> > +
cur_st_tch[CY_ST_FNGR2_IDX] =
> id;
> > +						}
> > +						st_x2 =
cur_mt_pos[id][CY_XPOS];
> > +						st_y2 =
cur_mt_pos[id][CY_YPOS];
> > +						st_z2 = cur_mt_z[id];
> > +						cyttsp_xdebug("ST STEP 2
- ST2
> ID=%3d\n", \
> > +
cur_st_tch[CY_ST_FNGR2_IDX]);
> > +					}
> > +				}
> > +			}
> > +		} else if (cur_st_tch[CY_ST_FNGR2_IDX] > CY_NUM_TRK_ID)
{
> > +			if (cur_tch > 1) {
> > +				/* reassign st finger2 */
> > +				if (ts->platform_data->use_trk_id) {
> > +					/* reassign st finger2 */
> > +					id = CY_MT_TCH2_IDX;
> > +					cur_st_tch[CY_ST_FNGR2_IDX] =
> > +						cur_mt_tch[id];
> > +				} else {
> > +					/* reassign st finger2 */
> > +					id =
GET_TOUCH2_ID(g_xy_data.touch12_id);
> > +					cur_st_tch[CY_ST_FNGR2_IDX] =
id;
> > +				}
> > +				st_x2 = cur_mt_pos[id][CY_XPOS];
> > +				st_y2 = cur_mt_pos[id][CY_YPOS];
> > +				st_z2 = cur_mt_z[id];
> > +				cyttsp_xdebug("ST STEP 3 - ST2
ID=%3d\n", \
> > +					cur_st_tch[CY_ST_FNGR2_IDX]);
> > +			}
> > +		}
> > +		/* if the 1st touch is missing and there is a 2nd touch,
> > +		 * then set the 1st touch to 2nd touch and terminate 2nd
> touch
> > +		 */
> > +		if ((cur_st_tch[CY_ST_FNGR1_IDX] > CY_NUM_TRK_ID) &&
> > +		    (cur_st_tch[CY_ST_FNGR2_IDX] < CY_NUM_TRK_ID)) {
> > +			st_x1 = st_x2;
> > +			st_y1 = st_y2;
> > +			st_z1 = st_z2;
> > +			cur_st_tch[CY_ST_FNGR1_IDX] =
> > +				cur_st_tch[CY_ST_FNGR2_IDX];
> > +			cur_st_tch[CY_ST_FNGR2_IDX] =
> > +				CY_IGNR_TCH;
> > +		}
> > +		/* if the 2nd touch ends up equal to the 1st touch,
> > +		 * then just report a single touch */
> > +		if (cur_st_tch[CY_ST_FNGR1_IDX] ==
> > +			cur_st_tch[CY_ST_FNGR2_IDX]) {
> > +			cur_st_tch[CY_ST_FNGR2_IDX] =
> > +				CY_IGNR_TCH;
> > +		}
> > +		/* set Single Touch current event signals */
> > +		if (cur_st_tch[CY_ST_FNGR1_IDX] < CY_NUM_TRK_ID) {
> > +			input_report_abs(ts->input,
> > +				ABS_X, st_x1);
> > +			input_report_abs(ts->input,
> > +				ABS_Y, st_y1);
> > +			input_report_abs(ts->input,
> > +				ABS_PRESSURE, st_z1);
> > +			input_report_key(ts->input,
> > +				BTN_TOUCH,
> > +				CY_TCH);
> > +			input_report_abs(ts->input,
> > +				ABS_TOOL_WIDTH,
> > +				curr_tool_width);
> > +			cyttsp_debug("ST->F1:%3d X:%3d Y:%3d Z:%3d\n", \
> > +				cur_st_tch[CY_ST_FNGR1_IDX], \
> > +				st_x1, st_y1, st_z1);
> > +			if (cur_st_tch[CY_ST_FNGR2_IDX] < CY_NUM_TRK_ID)
{
> > +				input_report_key(ts->input, BTN_2,
CY_TCH);
> > +				input_report_abs(ts->input, ABS_HAT0X,
st_x2);
> > +				input_report_abs(ts->input, ABS_HAT0Y,
st_y2);
> > +				cyttsp_debug("ST->F2:%3d X:%3d Y:%3d
Z:%3d\n",
> \
> > +					cur_st_tch[CY_ST_FNGR2_IDX],
> > +					st_x2, st_y2, st_z2);
> > +			} else {
> > +				input_report_key(ts->input,
> > +					BTN_2,
> > +					CY_NTCH);
> > +			}
> > +		} else {
> > +			input_report_abs(ts->input, ABS_PRESSURE,
CY_NTCH);
> > +			input_report_key(ts->input, BTN_TOUCH, CY_NTCH);
> > +			input_report_key(ts->input, BTN_2, CY_NTCH);
> > +		}
> > +		/* update platform data for the current single touch
info
> */
> > +		ts->prv_st_tch[CY_ST_FNGR1_IDX] =
> cur_st_tch[CY_ST_FNGR1_IDX];
> > +		ts->prv_st_tch[CY_ST_FNGR2_IDX] =
> cur_st_tch[CY_ST_FNGR2_IDX];
> > +
> > +	}
> > +
> > +	/* handle Multi-touch signals */
> > +	if (ts->platform_data->use_mt) {
> > +		if (ts->platform_data->use_trk_id) {
> > +			/* terminate any previous touch where the track
> > +			 * is missing from the current event */
> > +			for (id = 0; id < CY_NUM_TRK_ID; id++) {
> > +				if ((ts->act_trk[id] != CY_NTCH) &&
> > +					(cur_trk[id] == CY_NTCH)) {
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TRACKING_ID,
> > +						id);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TOUCH_MAJOR,
> > +						CY_NTCH);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_WIDTH_MAJOR,
> > +						curr_tool_width);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_X,
> > +
ts->prv_mt_pos[id][CY_XPOS]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_Y,
> > +
ts->prv_mt_pos[id][CY_YPOS]);
> > +					CY_MT_SYNC(ts->input);
> > +					ts->act_trk[id] = CY_NTCH;
> > +					ts->prv_mt_pos[id][CY_XPOS] = 0;
> > +					ts->prv_mt_pos[id][CY_YPOS] = 0;
> > +				}
> > +			}
> > +			/* set Multi-Touch current event signals */
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				if (cur_mt_tch[id] < CY_NUM_TRK_ID) {
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TRACKING_ID,
> > +						cur_mt_tch[id]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TOUCH_MAJOR,
> > +						cur_mt_z[id]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_WIDTH_MAJOR,
> > +						curr_tool_width);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_X,
> > +
cur_mt_pos[id][CY_XPOS]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_Y,
> > +
cur_mt_pos[id][CY_YPOS]);
> > +					CY_MT_SYNC(ts->input);
> > +					ts->act_trk[id] = CY_TCH;
> > +					ts->prv_mt_pos[id][CY_XPOS] =
> > +						cur_mt_pos[id][CY_XPOS];
> > +					ts->prv_mt_pos[id][CY_YPOS] =
> > +						cur_mt_pos[id][CY_YPOS];
> > +				}
> > +			}
> > +		} else {
> > +			/* set temporary track array elements to voids
*/
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				tmp_trk[id] = CY_IGNR_TCH;
> > +				snd_trk[id] = CY_IGNR_TCH;
> > +			}
> > +
> > +			/* get what is currently active */
> > +			for (i = 0, id = 0;
> > +				id < CY_NUM_TRK_ID && i <
CY_NUM_MT_TCH_ID;
> > +				id++) {
> > +				if (cur_trk[id] == CY_TCH) {
> > +					/* only incr counter if track
found */
> > +					tmp_trk[i] = id;
> > +					i++;
> > +				}
> > +			}
> > +			cyttsp_xdebug("T1: t0=%d, t1=%d, t2=%d,
t3=%d\n", \
> > +				tmp_trk[0], tmp_trk[1], tmp_trk[2], \
> > +				tmp_trk[3]);
> > +			cyttsp_xdebug("T1: p0=%d, p1=%d, p2=%d,
p3=%d\n", \
> > +				ts->prv_mt_tch[0], ts->prv_mt_tch[1], \
> > +				ts->prv_mt_tch[2], ts->prv_mt_tch[3]);
> > +
> > +			/* pack in still active previous touches */
> > +			for (id = 0, prv_tch = 0;
> > +				id < CY_NUM_MT_TCH_ID; id++) {
> > +				if (tmp_trk[id] < CY_NUM_TRK_ID) {
> > +					if
(cyttsp_inlist(ts->prv_mt_tch,
> > +						tmp_trk[id], &loc,
> > +						CY_NUM_MT_TCH_ID)) {
> > +						loc &= CY_NUM_MT_TCH_ID
- 1;
> > +						snd_trk[loc] =
tmp_trk[id];
> > +						prv_tch++;
> > +						cyttsp_xdebug("inlist
s[%d]=%d
> t[%d]=%d l=%d p=%d\n", \
> > +							loc,
snd_trk[loc], \
> > +							id, tmp_trk[id],
\
> > +							loc, prv_tch);
> > +					} else {
> > +						cyttsp_xdebug("not
inlist s[%d]=%d
> t[%d]=%d l=%d \n", \
> > +							id, snd_trk[id],
\
> > +							id, tmp_trk[id],
\
> > +							loc);
> > +					}
> > +				}
> > +			}
> > +			cyttsp_xdebug("S1: s0=%d, s1=%d, s2=%d, s3=%d
> p=%d\n", \
> > +				snd_trk[0], snd_trk[1], snd_trk[2], \
> > +				snd_trk[3], prv_tch);
> > +
> > +			/* pack in new touches */
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				if (tmp_trk[id] < CY_NUM_TRK_ID) {
> > +					if (!cyttsp_inlist(snd_trk,
tmp_trk[id],
> &loc, CY_NUM_MT_TCH_ID)) {
> > +						cyttsp_xdebug("not
inlist t[%d]=%d
> l=%d\n", \
> > +							id, tmp_trk[id],
loc);
> > +						if
> (cyttsp_next_avail_inlist(snd_trk, &loc, CY_NUM_MT_TCH_ID)) {
> > +							loc &=
CY_NUM_MT_TCH_ID - 1;
> > +							snd_trk[loc] =
tmp_trk[id];
> > +
cyttsp_xdebug("put inlist
> s[%d]=%d t[%d]=%d\n",
> > +								loc,
snd_trk[loc], id,
> tmp_trk[id]);
> > +						}
> > +					} else {
> > +						cyttsp_xdebug("is in
list s[%d]=%d
> t[%d]=%d loc=%d\n", \
> > +							id, snd_trk[id],
id,
> tmp_trk[id], loc);
> > +					}
> > +				}
> > +			}
> > +			cyttsp_xdebug("S2: s0=%d, s1=%d, s2=%d,
s3=%d\n", \
> > +				snd_trk[0], snd_trk[1],
> > +				snd_trk[2], snd_trk[3]);
> > +
> > +			/* sync motion event signals for each current
touch
> */
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				/* z will either be 0 (NOTOUCH) or
> > +				 * some pressure (TOUCH) */
> > +				cyttsp_xdebug("MT0 prev[%d]=%d
temp[%d]=%d
> send[%d]=%d\n", \
> > +					id, ts->prv_mt_tch[id], \
> > +					id, tmp_trk[id], \
> > +					id, snd_trk[id]);
> > +				if (snd_trk[id] < CY_NUM_TRK_ID) {
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TOUCH_MAJOR,
> > +						cur_mt_z[snd_trk[id]]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_WIDTH_MAJOR,
> > +						curr_tool_width);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_X,
> > +
cur_mt_pos[snd_trk[id]][CY_XPOS]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_Y,
> > +
cur_mt_pos[snd_trk[id]][CY_YPOS]);
> > +					CY_MT_SYNC(ts->input);
> > +					cyttsp_debug("MT1->TID:%2d X:%3d
Y:%3d
> Z:%3d touch-sent\n", \
> > +						snd_trk[id], \
> > +
cur_mt_pos[snd_trk[id]][CY_XPOS], \
> > +
cur_mt_pos[snd_trk[id]][CY_YPOS], \
> > +						cur_mt_z[snd_trk[id]]);
> > +				} else if (ts->prv_mt_tch[id] <
CY_NUM_TRK_ID)
> {
> > +					/* void out this touch */
> > +					input_report_abs(ts->input,
> > +						ABS_MT_TOUCH_MAJOR,
> > +						CY_NTCH);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_WIDTH_MAJOR,
> > +						curr_tool_width);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_X,
> > +						ts->prv_mt_pos[ts-
> >prv_mt_tch[id]][CY_XPOS]);
> > +					input_report_abs(ts->input,
> > +						ABS_MT_POSITION_Y,
> > +						ts->prv_mt_pos[ts-
> >prv_mt_tch[id]][CY_YPOS]);
> > +					CY_MT_SYNC(ts->input);
> > +					cyttsp_debug("MT2->TID:%2d X:%3d
Y:%3d
> Z:%3d lift off-sent\n", \
> > +						ts->prv_mt_tch[id], \
> > +						ts->prv_mt_pos[ts-
> >prv_mt_tch[id]][CY_XPOS], \
> > +						ts->prv_mt_pos[ts-
> >prv_mt_tch[id]][CY_YPOS], \
> > +						CY_NTCH);
> > +				} else {
> > +					/* do not stuff any signals for
this
> > +					 * previously and currently
> > +					 * void touches */
> > +					cyttsp_xdebug("MT3->send[%d]=%d
- No
> touch - NOT sent\n", \
> > +							id,
snd_trk[id]);
> > +				}
> > +			}
> > +
> > +			/* save current posted tracks to
> > +			 * previous track memory */
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				ts->prv_mt_tch[id] = snd_trk[id];
> > +				ts->prv_mt_pos[snd_trk[id]][CY_XPOS] =
> > +
cur_mt_pos[snd_trk[id]][CY_XPOS];
> > +				ts->prv_mt_pos[snd_trk[id]][CY_YPOS] =
> > +
cur_mt_pos[snd_trk[id]][CY_YPOS];
> > +				cyttsp_xdebug("MT4->TID:%2d X:%3d Y:%3d
Z:%3d
> save for previous\n", \
> > +					snd_trk[id], \
> > +
ts->prv_mt_pos[snd_trk[id]][CY_XPOS], \
> > +
ts->prv_mt_pos[snd_trk[id]][CY_YPOS], \
> > +					CY_NTCH);
> > +			}
> > +			for (id = 0; id < CY_NUM_TRK_ID; id++)
> > +				ts->act_trk[id] = CY_NTCH;
> > +			for (id = 0; id < CY_NUM_MT_TCH_ID; id++) {
> > +				if (snd_trk[id] < CY_NUM_TRK_ID)
> > +					ts->act_trk[snd_trk[id]] =
CY_TCH;
> > +			}
> > +		}
> > +	}
> > +
> > +	/* handle gestures */
> > +	if (ts->platform_data->use_gestures) {
> > +		if (g_xy_data.gest_id) {
> > +			input_report_key(ts->input,
> > +				BTN_3, CY_TCH);
> > +			input_report_abs(ts->input,
> > +				ABS_HAT1X, g_xy_data.gest_id);
> > +			input_report_abs(ts->input,
> > +				ABS_HAT2Y, g_xy_data.gest_cnt);
> > +		}
> > +	}
> > +
> > +	/* signal the view motion event */
> > +	input_sync(ts->input);
> > +
> > +	for (id = 0; id < CY_NUM_TRK_ID; id++) {
> > +		/* update platform data for the current MT information
*/
> > +		ts->act_trk[id] = cur_trk[id];
> > +	}
> > +
> > +exit_xy_worker:
> > +	if (cyttsp_disable_touch) {
> > +		/* Turn off the touch interrupts */
> > +		cyttsp_debug("Not enabling touch\n");
> > +	} else {
> > +		if (ts->client->irq == 0) {
> > +			/* restart event timer */
> > +			mod_timer(&ts->timer, jiffies +
TOUCHSCREEN_TIMEOUT);
> > +		} else {
> > +			/* re-enable the interrupt after processing */
> > +			enable_irq(ts->client->irq);
> > +		}
> > +	}
> > +	return;
> > +}
> > +
> > +static int cyttsp_inlist(u16 prev_track[], u8 cur_trk_id,
> > +			u8 *prev_loc, u8 num_touches)
> > +{
> 
> return could be "bool" instead of "int" right?
> 

Yes. In new code.

> > +	u8 id = 0;
> > +
> > +	*prev_loc = CY_IGNR_TCH;
> > +
> > +		cyttsp_xdebug("IN p[%d]=%d c=%d n=%d loc=%d\n", \
> > +			id, prev_track[id], cur_trk_id, \
> > +			num_touches, *prev_loc);
> 
> Indentation problem.
> 

New code should be clean.

> > +	for (id = 0, *prev_loc = CY_IGNR_TCH;
> > +		(id < num_touches); id++) {
> > +		cyttsp_xdebug("p[%d]=%d c=%d n=%d loc=%d\n", \
> > +			id, prev_track[id], cur_trk_id, \
> > +			num_touches, *prev_loc);
> > +		if (prev_track[id] == cur_trk_id) {
> > +			*prev_loc = id;
> > +			break;
> > +		}
> > +	}
> > +	cyttsp_xdebug("OUT p[%d]=%d c=%d n=%d loc=%d\n", \
> > +		id, prev_track[id], cur_trk_id, num_touches, *prev_loc);
> > +
> > +	return ((*prev_loc < CY_NUM_TRK_ID) ? true : false);
> > +}
> > +
> > +static int cyttsp_next_avail_inlist(u16 cur_trk[],
> > +			u8 *new_loc, u8 num_touches)
> > +{
> 
> return could be "bool" instead of "int" right?
> 

Yes. In new code.

> > +	u8 id;
> > +
> > +	for (id = 0, *new_loc = CY_IGNR_TCH;
> > +		(id < num_touches); id++) {
> > +		if (cur_trk[id] > CY_NUM_TRK_ID) {
> > +			*new_loc = id;
> > +			break;
> > +		}
> > +	}
> > +
> > +	return ((*new_loc < CY_NUM_TRK_ID) ? true : false);
> > +}
> > +
> > +/* Timer function used as dummy interrupt driver */
> > +static void cyttsp_timer(unsigned long handle)
> > +{
> > +	struct cyttsp *ts = (struct cyttsp *) handle;
> > +
> > +	cyttsp_xdebug("TTSP Device timer event\n");
> > +
> > +	/* schedule motion signal handling */
> > +	queue_work(cyttsp_ts_wq, &ts->work);
> > +
> > +	return;
> > +}
> > +
> > +
> > +
> > +/*
>
***********************************************************************
> *
> > + * ISR function. This function is general, initialized in drivers
> init
> > + * function
> > + *
>
***********************************************************************
> * */
> > +static irqreturn_t cyttsp_irq(int irq, void *handle)
> > +{
> > +	struct cyttsp *ts = (struct cyttsp *) handle;
> > +
> > +	cyttsp_xdebug("%s: Got IRQ\n", CY_I2C_NAME);
> > +
> > +	/* disable further interrupts until this interrupt is processed
> */
> > +	disable_irq_nosync(ts->client->irq);
> 
> As indicated below please use request_threaded_irq(..).
> 
> 

New code uses request_threaded_irq().

> > +
> > +	/* schedule motion signal handling */
> > +	queue_work(cyttsp_ts_wq, &ts->work);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +/*
>
***********************************************************************
> *
> > + * Probe initialization functions
> > + *
>
***********************************************************************
> * */
> > +static int cyttsp_putbl(struct cyttsp *ts, int show,
> > +			int show_status, int show_version, int show_cid)
> > +{
> > +	int retval = CY_OK;
> > +
> > +	int num_bytes = (show_status * 3) + (show_version * 6) +
> (show_cid * 3);
> > +
> > +	if (show_cid)
> > +		num_bytes = sizeof(struct cyttsp_bootloader_data_t);
> > +	else if (show_version)
> > +		num_bytes = sizeof(struct cyttsp_bootloader_data_t) - 3;
> > +	else
> > +		num_bytes = sizeof(struct cyttsp_bootloader_data_t) - 9;
> > +
> > +	if (show) {
> > +		retval = i2c_smbus_read_i2c_block_data(ts->client,
> > +			CY_REG_BASE, num_bytes, (u8 *)&g_bl_data);
> > +		if (show_status) {
> > +			cyttsp_debug("BL%d: f=%02X s=%02X err=%02X
> bl=%02X%02X bld=%02X%02X\n", \
> > +				show, \
> > +				g_bl_data.bl_file, \
> > +				g_bl_data.bl_status, \
> > +				g_bl_data.bl_error, \
> > +				g_bl_data.blver_hi, g_bl_data.blver_lo,
\
> > +				g_bl_data.bld_blver_hi,
> g_bl_data.bld_blver_lo);
> > +		}
> > +		if (show_version) {
> > +			cyttsp_debug("BL%d: ttspver=0x%02X%02X
> appid=0x%02X%02X appver=0x%02X%02X\n", \
> > +				show, \
> > +				g_bl_data.ttspver_hi,
g_bl_data.ttspver_lo, \
> > +				g_bl_data.appid_hi, g_bl_data.appid_lo,
\
> > +				g_bl_data.appver_hi,
g_bl_data.appver_lo);
> > +		}
> > +		if (show_cid) {
> > +			cyttsp_debug("BL%d: cid=0x%02X%02X%02X\n", \
> > +				show, \
> > +				g_bl_data.cid_0, \
> > +				g_bl_data.cid_1, \
> > +				g_bl_data.cid_2);
> > +		}
> > +		mdelay(CY_DLY_DFLT);
> > +	}
> > +
> > +	return retval;
> > +}
> > +
> > +#ifdef CY_INCLUDE_LOAD_FILE
> 
> Could you please explain what is the use of this #define?
> 
> Are we loading any firmware? Please explain why we can't use
> request_firware(...).
> 

New code replaces included code with file based loader support.

> > +#define CY_MAX_I2C_LEN	256
> > +#define CY_MAX_TRY		10
> > +#define CY_BL_PAGE_SIZE	16
> > +#define CY_BL_NUM_PAGES	5
> > +static int cyttsp_i2c_wr_blk_data(struct i2c_client *client, u8
> command,
> > +			       u8 length, const u8 *values)
> > +{
> > +	int retval = CY_OK;
> > +
> > +	u8 dataray[CY_MAX_I2C_LEN];
> > +	u8 try;
> > +	dataray[0] = command;
> > +	if (length)
> > +		memcpy(&dataray[1], values, length);
> > +
> > +	try = CY_MAX_TRY;
> > +	do {
> > +		retval = i2c_master_send(client, dataray, length+1);
> > +		mdelay(CY_DLY_DFLT*2);
> > +	} while ((retval != length+1) && try--);
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_i2c_wr_blk_chunks(struct cyttsp *ts, u8 command,
> > +			       u8 length, const u8 *values)
> > +{
> > +	int retval = CY_OK;
> > +	int block = 1;
> > +
> > +	u8 dataray[CY_MAX_I2C_LEN];
> > +
> > +	/* first page already includes the bl page offset */
> > +	retval = i2c_smbus_write_i2c_block_data(ts->client, CY_REG_BASE,
> > +		CY_BL_PAGE_SIZE+1, values);
> > +	mdelay(10);
> > +	values += CY_BL_PAGE_SIZE+1;
> > +	length -= CY_BL_PAGE_SIZE+1;
> > +
> > +	/* rem blocks require bl page offset stuffing */
> > +	while (length &&
> > +		(block < CY_BL_NUM_PAGES) &&
> > +		!(retval < CY_OK)) {
> > +		dataray[0] = CY_BL_PAGE_SIZE*block;
> > +		memcpy(&dataray[1], values,
> > +			length >= CY_BL_PAGE_SIZE ?
> > +			CY_BL_PAGE_SIZE : length);
> > +		retval = i2c_smbus_write_i2c_block_data(ts->client,
> > +			CY_REG_BASE,
> > +			length >= CY_BL_PAGE_SIZE ?
> > +			CY_BL_PAGE_SIZE + 1 : length+1, dataray);
> > +		mdelay(10);
> > +		values += CY_BL_PAGE_SIZE;
> > +		length = length >= CY_BL_PAGE_SIZE ?
> > +			length - CY_BL_PAGE_SIZE : 0;
> > +		block++;
> > +	}
> > +
> > +	return retval;
> > +}
> > +
> > +static int cyttsp_bootload_app(struct cyttsp *ts)
> > +{
> > +	int retval = CY_OK;
> > +	int i, tries;
> > +	u8 host_reg;
> > +
> > +	cyttsp_debug("load new firmware \n");
> > +	/* reset TTSP Device back to bootloader mode */
> > +	host_reg = CY_SOFT_RESET_MODE;
> > +	retval = i2c_smbus_write_i2c_block_data(ts->client, CY_REG_BASE,
> > +		sizeof(host_reg), &host_reg);
> > +	/* wait for TTSP Device to complete reset back to bootloader */
> > +	mdelay(1000);
> > +	cyttsp_putbl(ts, 3, true, true, true);
> > +	cyttsp_debug("load file - tver=0x%02X%02X a_id=0x%02X%02X
> aver=0x%02X%02X\n", \
> > +		cyttsp_fw_tts_verh, cyttsp_fw_tts_verl, \
> > +		cyttsp_fw_app_idh, cyttsp_fw_app_idl, \
> > +		cyttsp_fw_app_verh, cyttsp_fw_app_verl);
> > +
> > +	/* download new TTSP Application to the Bootloader */
> > +	if (!(retval < CY_OK)) {
> > +		i = 0;
> > +		/* send bootload initiation command */
> > +		if (cyttsp_fw[i].Command == CY_BL_INIT_LOAD) {
> > +			g_bl_data.bl_file = 0;
> > +			g_bl_data.bl_status = 0;
> > +			g_bl_data.bl_error = 0;
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				cyttsp_fw[i].Length,
cyttsp_fw[i].Block);
> > +			/* delay to allow bl to get ready for block
writes */
> > +			i++;
> > +			tries = 0;
> > +			cyttsp_debug("wait init f=%02X, s=%02X, e=%02X
> t=%d\n", \
> > +				g_bl_data.bl_file, g_bl_data.bl_status,
\
> > +				g_bl_data.bl_error, tries);
> > +			do {
> > +				mdelay(1000);
> > +				cyttsp_putbl(ts, 4, true, false, false);
> > +			} while (g_bl_data.bl_status != 0x10 &&
> > +				g_bl_data.bl_status != 0x11 &&
> > +				tries++ < 10);
> > +			/* send bootload firmware load blocks */
> > +			if (!(retval < CY_OK)) {
> > +				while (cyttsp_fw[i].Command ==
CY_BL_WRITE_BLK)
> {
> > +					retval =
cyttsp_i2c_wr_blk_chunks(ts,
> > +						CY_REG_BASE,
> > +						cyttsp_fw[i].Length,
> > +						cyttsp_fw[i].Block);
> > +					/* bl requires dly after blocks
*/
> > +					mdelay(100);
> > +					cyttsp_debug("BL DNLD Rec=% 3d
Len=% 3d
> Addr=%04X\n", \
> > +						cyttsp_fw[i].Record, \
> > +						cyttsp_fw[i].Length, \
> > +						cyttsp_fw[i].Address);
> > +					i++;
> > +					if (retval < CY_OK) {
> > +						cyttsp_debug("BL fail
Rec=%3d
> retval=%d\n", \
> > +
cyttsp_fw[i-1].Record, \
> > +							retval);
> > +						break;
> > +					} else {
> > +						/* reset TTSP I2C
counter */
> > +						retval =
cyttsp_i2c_wr_blk_data(ts-
> >client,
> > +							CY_REG_BASE,
> > +							0, NULL);
> > +						mdelay(10);
> > +						cyttsp_putbl(ts, 5,
> > +							true, false,
false);
> > +					}
> > +				}
> > +				if (!(retval < CY_OK)) {
> > +					while (i < cyttsp_fw_records) {
> > +						retval =
> i2c_smbus_write_i2c_block_data(ts->client, CY_REG_BASE,
> > +
cyttsp_fw[i].Length,
> > +
cyttsp_fw[i].Block);
> > +						i++;
> > +						tries = 0;
> > +						cyttsp_debug("wait init
f=%02X,
> s=%02X, e=%02X t=%d\n", \
> > +
g_bl_data.bl_file, \
> > +
g_bl_data.bl_status, \
> > +
g_bl_data.bl_error, \
> > +							tries);
> > +						do {
> > +							mdelay(1000);
> > +							cyttsp_putbl(ts,
6, true,
> false, false);
> > +						} while
(g_bl_data.bl_status !=
> 0x10 &&
> > +
g_bl_data.bl_status != 0x11
> &&
> > +							tries++ < 10);
> > +						cyttsp_putbl(ts, 7,
true, false,
> > +							false);
> > +						if (retval < CY_OK)
> > +							break;
> > +					}
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	/* reset TTSP Device back to bootloader mode */
> > +	host_reg = CY_SOFT_RESET_MODE;
> > +	retval = i2c_smbus_write_i2c_block_data(ts->client, CY_REG_BASE,
> > +		sizeof(host_reg), &host_reg);
> > +	/* wait for TTSP Device to complete reset back to bootloader */
> > +	mdelay(1000);
> > +
> > +	/* set arg2 to non-0 to activate */
> > +	retval = cyttsp_putbl(ts, 8, true, true, true);
> > +
> > +	return retval;
> > +}
> > +#else
> > +static int cyttsp_bootload_app(struct cyttsp *ts)
> > +{
> > +	cyttsp_debug("no-load new firmware \n");
> > +	return CY_OK;
> > +}
> > +#endif /* CY_INCLUDE_LOAD_FILE */
> > +
> > +
> > +static int cyttsp_power_on(struct cyttsp *ts)
> > +{
> > +	int retval = CY_OK;
> > +	u8 host_reg;
> > +	int tries;
> > +
> > +	cyttsp_debug("Power up \n");
> > +
> > +	/* check if the TTSP device has a bootloader installed */
> > +	host_reg = CY_SOFT_RESET_MODE;
> > +	retval = i2c_smbus_write_i2c_block_data(ts->client, CY_REG_BASE,
> > +		sizeof(host_reg), &host_reg);
> > +	tries = 0;
> > +	do {
> > +		mdelay(1000);
> > +
> > +		/* set arg2 to non-0 to activate */
> > +		retval = cyttsp_putbl(ts, 1, true, true, true);
> > +		cyttsp_info("BL%d: f=%02X s=%02X err=%02X bl=%02X%02X
> bld=%02X%02X R=%d\n", \
> > +			101, \
> > +			g_bl_data.bl_file, g_bl_data.bl_status, \
> > +			g_bl_data.bl_error, \
> > +			g_bl_data.blver_hi, g_bl_data.blver_lo, \
> > +			g_bl_data.bld_blver_hi, g_bl_data.bld_blver_lo,
> > +			retval);
> > +		cyttsp_info("BL%d: tver=%02X%02X a_id=%02X%02X
> aver=%02X%02X\n", \
> > +			102, \
> > +			g_bl_data.ttspver_hi, g_bl_data.ttspver_lo, \
> > +			g_bl_data.appid_hi, g_bl_data.appid_lo, \
> > +			g_bl_data.appver_hi, g_bl_data.appver_lo);
> > +		cyttsp_info("BL%d: c_id=%02X%02X%02X\n", \
> > +			103, \
> > +			g_bl_data.cid_0, g_bl_data.cid_1,
g_bl_data.cid_2);
> > +	} while (!(retval < CY_OK) &&
> > +		!GET_BOOTLOADERMODE(g_bl_data.bl_status) &&
> > +		!(g_bl_data.bl_file == CY_OP_MODE + CY_LOW_PWR_MODE) &&
> > +		tries++ < 10);
> > +
> > +	/* is bootloader missing? */
> > +	if (!(retval < CY_OK)) {
> > +		cyttsp_xdebug("Ret=%d  Check if bootloader is
> missing...\n", \
> > +			retval);
> > +		if (!GET_BOOTLOADERMODE(g_bl_data.bl_status)) {
> > +			/* skip all bl and sys info and go to op mode */
> > +			if (!(retval < CY_OK)) {
> > +				cyttsp_xdebug("Bl is missing
(ret=%d)\n", \
> > +					retval);
> > +				host_reg = CY_OP_MODE/* +
CY_LOW_PWR_MODE*/;
> > +				retval =
i2c_smbus_write_i2c_block_data(ts-
> >client, CY_REG_BASE,
> > +					sizeof(host_reg), &host_reg);
> > +				/* wait for TTSP Device to complete
switch to
> > +				 * Operational mode */
> > +				mdelay(1000);
> > +				goto bypass;
> > +			}
> > +		}
> > +	}
> > +
> > +
> > +	/* take TTSP out of bootloader mode; go to TrueTouch operational
> mode */
> > +	if (!(retval < CY_OK)) {
> > +		cyttsp_xdebug1("exit bootloader; go operational\n");
> > +		retval = i2c_smbus_write_i2c_block_data(ts->client,
> > +			CY_REG_BASE, sizeof(bl_cmd), bl_cmd);
> > +		tries = 0;
> > +		do {
> > +			mdelay(1000);
> > +			cyttsp_putbl(ts, 4, true, false, false);
> > +			cyttsp_info("BL%d: f=%02X s=%02X err=%02X
bl=%02X%02X
> bld=%02X%02X\n", \
> > +				104, \
> > +				g_bl_data.bl_file, g_bl_data.bl_status,
\
> > +				g_bl_data.bl_error, \
> > +				g_bl_data.blver_hi, g_bl_data.blver_lo,
\
> > +				g_bl_data.bld_blver_hi,
> g_bl_data.bld_blver_lo);
> > +		} while (GET_BOOTLOADERMODE(g_bl_data.bl_status) &&
> > +			tries++ < 10);
> > +	}
> > +
> > +
> > +
> > +	if (!(retval < CY_OK) &&
> > +		cyttsp_app_load()) {
> > +		mdelay(1000);
> > +		if (CY_DIFF(g_bl_data.ttspver_hi, cyttsp_tts_verh())  ||
> > +			CY_DIFF(g_bl_data.ttspver_lo, cyttsp_tts_verl())
||
> > +			CY_DIFF(g_bl_data.appid_hi, cyttsp_app_idh())
||
> > +			CY_DIFF(g_bl_data.appid_lo, cyttsp_app_idl())
||
> > +			CY_DIFF(g_bl_data.appver_hi, cyttsp_app_verh())
||
> > +			CY_DIFF(g_bl_data.appver_lo, cyttsp_app_verl())
||
> > +			CY_DIFF(g_bl_data.cid_0, cyttsp_cid_0())  ||
> > +			CY_DIFF(g_bl_data.cid_1, cyttsp_cid_1())  ||
> > +			CY_DIFF(g_bl_data.cid_2, cyttsp_cid_2())  ||
> > +			cyttsp_force_fw_load()) {
> > +			cyttsp_debug("blttsp=0x%02X%02X
flttsp=0x%02X%02X
> force=%d\n", \
> > +				g_bl_data.ttspver_hi,
g_bl_data.ttspver_lo, \
> > +				cyttsp_tts_verh(), cyttsp_tts_verl(), \
> > +				cyttsp_force_fw_load());
> > +			cyttsp_debug("blappid=0x%02X%02X
> flappid=0x%02X%02X\n", \
> > +				g_bl_data.appid_hi, g_bl_data.appid_lo,
\
> > +				cyttsp_app_idh(), cyttsp_app_idl());
> > +			cyttsp_debug("blappver=0x%02X%02X
> flappver=0x%02X%02X\n", \
> > +				g_bl_data.appver_hi,
g_bl_data.appver_lo, \
> > +				cyttsp_app_verh(), cyttsp_app_verl());
> > +			cyttsp_debug("blcid=0x%02X%02X%02X
> flcid=0x%02X%02X%02X\n", \
> > +				g_bl_data.cid_0, \
> > +				g_bl_data.cid_1, \
> > +				g_bl_data.cid_2, \
> > +				cyttsp_cid_0(), \
> > +				cyttsp_cid_1(), \
> > +				cyttsp_cid_2());
> > +			/* enter bootloader to load new app into TTSP
Device
> */
> > +			retval = cyttsp_bootload_app(ts);
> > +			/* take TTSP device out of bootloader mode;
> > +			 * switch back to TrueTouch operational mode */
> > +			if (!(retval < CY_OK)) {
> > +				retval =
i2c_smbus_write_i2c_block_data(ts-
> >client,
> > +					CY_REG_BASE,
> > +					sizeof(bl_cmd), bl_cmd);
> > +				/* wait for TTSP Device to complete
> > +				 * switch to Operational mode */
> > +				mdelay(1000);
> > +			}
> > +		}
> > +	}
> > +
> > +bypass:
> > +	/* switch to System Information mode to read versions
> > +	 * and set interval registers */
> > +	if (!(retval < CY_OK)) {
> > +		cyttsp_debug("switch to sysinfo mode \n");
> > +		host_reg = CY_SYSINFO_MODE;
> > +		retval = i2c_smbus_write_i2c_block_data(ts->client,
> > +			CY_REG_BASE, sizeof(host_reg), &host_reg);
> > +		/* wait for TTSP Device to complete switch to SysInfo
mode
> */
> > +		mdelay(1000);
> > +		if (!(retval < CY_OK)) {
> > +			retval =
i2c_smbus_read_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(struct cyttsp_sysinfo_data_t),
> > +				(u8 *)&g_sysinfo_data);
> > +			cyttsp_debug("SI2: hst_mode=0x%02X
mfg_cmd=0x%02X
> mfg_stat=0x%02X\n", \
> > +				g_sysinfo_data.hst_mode, \
> > +				g_sysinfo_data.mfg_cmd, \
> > +				g_sysinfo_data.mfg_stat);
> > +			cyttsp_debug("SI2: bl_ver=0x%02X%02X\n", \
> > +				g_sysinfo_data.bl_verh, \
> > +				g_sysinfo_data.bl_verl);
> > +			cyttsp_debug("SI2: sysinfo act_int=0x%02X
> tch_tmout=0x%02X lp_int=0x%02X\n", \
> > +				g_sysinfo_data.act_intrvl, \
> > +				g_sysinfo_data.tch_tmout, \
> > +				g_sysinfo_data.lp_intrvl);
> > +			cyttsp_info("SI%d: tver=%02X%02X a_id=%02X%02X
> aver=%02X%02X\n", \
> > +				102, \
> > +				g_sysinfo_data.tts_verh, \
> > +				g_sysinfo_data.tts_verl, \
> > +				g_sysinfo_data.app_idh, \
> > +				g_sysinfo_data.app_idl, \
> > +				g_sysinfo_data.app_verh, \
> > +				g_sysinfo_data.app_verl);
> > +			cyttsp_info("SI%d: c_id=%02X%02X%02X\n", \
> > +				103, \
> > +				g_sysinfo_data.cid[0], \
> > +				g_sysinfo_data.cid[1], \
> > +				g_sysinfo_data.cid[2]);
> > +			if (!(retval < CY_OK) &&
> > +				(CY_DIFF(ts->platform_data->act_intrvl,
> > +					CY_ACT_INTRVL_DFLT)  ||
> > +				CY_DIFF(ts->platform_data->tch_tmout,
> > +					CY_TCH_TMOUT_DFLT) ||
> > +				CY_DIFF(ts->platform_data->lp_intrvl,
> > +					CY_LP_INTRVL_DFLT))) {
> > +				if (!(retval < CY_OK)) {
> > +					u8
intrvl_ray[sizeof(ts->platform_data-
> >act_intrvl) +
> > +
sizeof(ts->platform_data-
> >tch_tmout) +
> > +
sizeof(ts->platform_data-
> >lp_intrvl)];
> > +					u8 i = 0;
> > +
> > +					intrvl_ray[i++] =
> > +
ts->platform_data->act_intrvl;
> > +					intrvl_ray[i++] =
> > +
ts->platform_data->tch_tmout;
> > +					intrvl_ray[i++] =
> > +
ts->platform_data->lp_intrvl;
> > +
> > +					cyttsp_debug("SI2: platinfo
> act_intrvl=0x%02X tch_tmout=0x%02X lp_intrvl=0x%02X\n", \
> > +
ts->platform_data->act_intrvl, \
> > +
ts->platform_data->tch_tmout, \
> > +
ts->platform_data->lp_intrvl);
> > +					/* set intrvl registers */
> > +					retval =
i2c_smbus_write_i2c_block_data(
> > +						ts->client,
> > +						CY_REG_ACT_INTRVL,
> > +						sizeof(intrvl_ray),
intrvl_ray);
> > +					mdelay(CY_DLY_SYSINFO);
> > +				}
> > +			}
> > +		}
> > +		/* switch back to Operational mode */
> > +		cyttsp_debug("switch back to operational mode \n");
> > +		if (!(retval < CY_OK)) {
> > +			host_reg = CY_OP_MODE/* + CY_LOW_PWR_MODE*/;
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(host_reg), &host_reg);
> > +			/* wait for TTSP Device to complete
> > +			 * switch to Operational mode */
> > +			mdelay(1000);
> > +		}
> > +	}
> > +	/* init gesture setup;
> > +	 * this is required even if not using gestures
> > +	 * in order to set the active distance */
> > +	if (!(retval < CY_OK)) {
> > +		u8 gesture_setup;
> > +		cyttsp_debug("init gesture setup \n");
> > +		gesture_setup = ts->platform_data->gest_set;
> > +		retval = i2c_smbus_write_i2c_block_data(ts->client,
> > +			CY_REG_GEST_SET,
> > +			sizeof(gesture_setup), &gesture_setup);
> > +		mdelay(CY_DLY_DFLT);
> > +	}
> > +
> > +	if (!(retval < CY_OK))
> > +		ts->platform_data->power_state = CY_ACTIVE_STATE;
> > +	else
> > +		ts->platform_data->power_state = CY_IDLE_STATE;
> > +
> > +	cyttsp_debug("Retval=%d Power state is %s\n", \
> > +		retval, \
> > +		ts->platform_data->power_state == CY_ACTIVE_STATE ? \
> > +		 "ACTIVE" : "IDLE");
> 
> Whole function looks scary and hard to understand. Is it possible to
> break it into the smaller
> functionality so that it becomes easy to understand.
> 

New refactored code breaks this into modules for clarity and reuse.

> > +
> > +	return retval;
> > +}
> > +
> > +/* cyttsp_initialize: Driver Initialization. This function takes
> > + * care of the following tasks:
> > + * 1. Create and register an input device with input layer
> > + * 2. Take CYTTSP device out of bootloader mode; go operational
> > + * 3. Start any timers/Work queues.  */
> > +static int cyttsp_initialize(struct i2c_client *client, struct
> cyttsp *ts)
> > +{
> > +	struct input_dev *input_device;
> > +	int error = 0;
> > +	int retval = CY_OK;
> > +	u8 id;
> > +
> > +	/* Create the input device and register it. */
> > +	input_device = input_allocate_device();
> > +	if (!input_device) {
> > +		error = -ENOMEM;
> > +		cyttsp_xdebug1("err input allocate device\n");
> > +		goto error_free_device;
> > +	}
> > +
> > +	if (!client) {
> > +		error = ~ENODEV;
> > +		cyttsp_xdebug1("err client is Null\n");
> > +		goto error_free_device;
> > +	}
> 
> Why you are checking !client here?
> 

Fixed in new code.

> > +
> > +	if (!ts) {
> > +		error = ~ENODEV;
> 
> ~? It should be -ENODEV, right?
> 

Correct. Fixed in new code.

> > +		cyttsp_xdebug1("err context is Null\n");
> > +		goto error_free_device;
> > +	}
> > +
> > +	ts->input = input_device;
> > +	input_device->name = CY_I2C_NAME;
> > +	input_device->phys = ts->phys;
> > +	input_device->dev.parent = &client->dev;
> > +
> > +	/* init the touch structures */
> > +	ts->num_prv_st_tch = CY_NTCH;
> > +	for (id = 0; id < CY_NUM_TRK_ID; id++) {
> > +		ts->act_trk[id] = CY_NTCH;
> > +		ts->prv_mt_pos[id][CY_XPOS] = 0;
> > +		ts->prv_mt_pos[id][CY_YPOS] = 0;
> > +	}
> > +
> > +	for (id = 0; id < CY_NUM_MT_TCH_ID; id++)
> > +		ts->prv_mt_tch[id] = CY_IGNR_TCH;
> > +
> > +	for (id = 0; id < CY_NUM_ST_TCH_ID; id++)
> > +		ts->prv_st_tch[id] = CY_IGNR_TCH;
> > +
> > +	set_bit(EV_SYN, input_device->evbit);
> > +	set_bit(EV_KEY, input_device->evbit);
> > +	set_bit(EV_ABS, input_device->evbit);
> > +	set_bit(BTN_TOUCH, input_device->keybit);
> > +	set_bit(BTN_2, input_device->keybit);
> 
> You need not use atomic versions. Please use __set_bit.
> 

Converted to use __set_bit() calls.

> > +	if (ts->platform_data->use_gestures)
> > +		set_bit(BTN_3, input_device->keybit);
> > +
> > +	input_set_abs_params(input_device,
> > +		ABS_X, 0, ts->platform_data->maxx, 0, 0);
> > +	input_set_abs_params(input_device,
> > +		ABS_Y, 0, ts->platform_data->maxy, 0, 0);
> > +	input_set_abs_params(input_device,
> > +		ABS_TOOL_WIDTH, 0, CY_LARGE_TOOL_WIDTH, 0 , 0);
> > +	input_set_abs_params(input_device,
> > +		ABS_PRESSURE, 0, CY_MAXZ, 0, 0);
> > +	input_set_abs_params(input_device,
> > +		ABS_HAT0X, 0, ts->platform_data->maxx, 0, 0);
> > +	input_set_abs_params(input_device,
> > +		ABS_HAT0Y, 0, ts->platform_data->maxy, 0, 0);
> 
> Why you are using HATxx? MT should be able to satisfy all the
> requirements.
>

Code includes Single_Touch handling to support developers with older
platform trees.  Single-touch is a board configuration selection item.
 
> > +	if (ts->platform_data->use_gestures) {
> > +		input_set_abs_params(input_device,
> > +			ABS_HAT1X, 0, CY_MAXZ, 0, 0);
> > +		input_set_abs_params(input_device,
> > +			ABS_HAT1Y, 0, CY_MAXZ, 0, 0);
> > +	}
> > +	if (ts->platform_data->use_mt) {
> > +		input_set_abs_params(input_device,
> > +			ABS_MT_POSITION_X, 0, ts->platform_data->maxx,
0, 0);
> > +		input_set_abs_params(input_device,
> > +			ABS_MT_POSITION_Y, 0, ts->platform_data->maxy,
0, 0);
> > +		input_set_abs_params(input_device,
> > +			ABS_MT_TOUCH_MAJOR, 0, CY_MAXZ, 0, 0);
> > +		input_set_abs_params(input_device,
> > +			ABS_MT_WIDTH_MAJOR, 0, CY_LARGE_TOOL_WIDTH, 0,
0);
> > +		if (ts->platform_data->use_trk_id) {
> > +			input_set_abs_params(input_device,
> > +				ABS_MT_TRACKING_ID, 0, CY_NUM_TRK_ID, 0,
0);
> > +		}
> > +	}
> > +
> > +	/* set dummy key to make driver work with virtual keys */
> > +	input_set_capability(input_device, EV_KEY, KEY_PROG1);
> 
> What is virtual keys and how they are supported?
> 

By enabling programmable keys, the developer can define regions of the
touch surface that can be translated to button presses.  The regions can
be defined in the board configuration file.

> > +
> > +	cyttsp_info("%s: Register input device\n", CY_I2C_NAME);
> > +	error = input_register_device(input_device);
> > +	if (error) {
> > +		cyttsp_alert("%s: Failed to register input device\n", \
> > +			CY_I2C_NAME);
> > +		retval = error;
> > +		goto error_free_device;
> > +	}
> > +
> > +	/* Prepare our worker structure prior to setting up the
timer/ISR
> */
> > +	INIT_WORK(&ts->work, cyttsp_xy_worker);
> > +
> > +	/* Power on the chip and make sure that I/Os are set as
specified
> > +	 * in the platform */
> > +	if (ts->platform_data->init)
> > +		retval = ts->platform_data->init(client);
> > +
> > +	if (!(retval < CY_OK))
> > +		retval = cyttsp_power_on(ts);
> > +
> > +	if (retval < 0)
> > +		goto error_free_device;
> 
> Wrong.
> 
> if (!rc) {
>      rc = power_on(ts);
>      if (!rc) {
>          rc = -Exxx;
>          goto error_path;
>      }
> }
>

The new code has been reworked.
 
> > +
> > +	/* Timer or Interrupt setup */
> > +	if (ts->client->irq == 0) {
> > +		cyttsp_info("Setting up timer\n");
> > +		setup_timer(&ts->timer, cyttsp_timer, (unsigned long)
ts);
> > +		mod_timer(&ts->timer, jiffies + TOUCHSCREEN_TIMEOUT);
> 
> Please support only one mode in the driver. Most of the time polling
> mode is used
> only during early development phase when the IRQs doesn't work, but we
> don't want to carry
> this code here.
> 
> Please remove polling mode code.
> 

We require supporting developers that have polling models.

> > +	} else {
> > +		cyttsp_info("Setting up interrupt\n");
> > +		/* request_irq() will also call enable_irq() */
> > +		error = request_irq(client->irq, cyttsp_irq,
> > +			IRQF_TRIGGER_FALLING,
> > +			client->dev.driver->name, ts);
> 
> Please use request_threaded_irq(...) with IRQF_ONESHOT flag.
>

Done in new code.
 
> > +		if (error) {
> > +			cyttsp_alert("error: could not request irq\n");
> > +			retval = error;
> > +			goto error_free_irq;
> > +		}
> > +	}
> > +
> > +	irq_cnt = 0;
> > +	irq_cnt_total = 0;
> > +	irq_err_cnt = 0;
> > +
> > +	atomic_set(&ts->irq_enabled, 1);
> > +	retval = device_create_file(&ts->client->dev,
> &dev_attr_irq_enable);
> > +	if (retval < CY_OK) {
> > +		cyttsp_alert("File device creation failed: %d\n",
retval);
> > +		retval = -ENODEV;
> > +		goto error_free_irq;
> > +	}
> > +
> > +	cyttsp_info("%s: Successful registration\n", CY_I2C_NAME);
> > +	goto success;
> > +
> > +error_free_irq:
> > +	cyttsp_alert("Error: Failed to register IRQ handler\n");
> > +	free_irq(client->irq, ts);
> > +
> > +error_free_device:
> > +	if (input_device)
> > +		input_free_device(input_device);
> > +
> > +success:
> > +	return retval;
> > +}
> > +
> > +/* I2C driver probe function */
> > +static int __devinit cyttsp_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id)
> > +{
> > +	struct cyttsp *ts;
> > +	int error;
> > +	int retval = CY_OK;
> 
> Please don't define your own error return codes. Use appropriate one
> from the kernel like say -EINVAL etc.,
> 

Error code defines eliminated.

> > +
> > +	cyttsp_info("Start Probe 1.2\n");
> 
> Please remove such debug statements. They are of no use.
> 

Custom debug statements removed.  New code uses printk() calls.

> I don't see call to i2c_check_functionality(...)
> 

Added in new code.

> > +
> > +	/* allocate and clear memory */
> > +	ts = kzalloc(sizeof(struct cyttsp), GFP_KERNEL);
> > +	if (ts == NULL) {
> > +		cyttsp_xdebug1("err kzalloc for cyttsp\n");
> 
> Please use dev_dbg or pr_debug provided by kernel only. This comment
> applies to whole driver.
> We don't need driver specific macros please.
> 

New code uses printk() calls.

> > +		retval = -ENOMEM;
> > +	}
> > +
> > +	if (!(retval < CY_OK)) {
> > +		/* register driver_data */
> > +		ts->client = client;
> > +		ts->platform_data = client->dev.platform_data;
> > +		i2c_set_clientdata(client, ts);
> > +
> > +		error = cyttsp_initialize(client, ts);
> > +		if (error) {
> > +			cyttsp_xdebug1("err cyttsp_initialize\n");
> > +			if (ts != NULL) {
> > +				/* deallocate memory */
> > +				kfree(ts);
> > +			}
> > +/*
> > +			i2c_del_driver(&cyttsp_driver);
> > +*/
> 
> Do you need this commented out code?
> 

New code has no commented out code.

> > +			retval = -ENODEV;
> > +		} else
> > +			cyttsp_openlog();
> > +	}
> > +
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +	if (!(retval < CY_OK)) {
> > +		ts->early_suspend.level =
EARLY_SUSPEND_LEVEL_BLANK_SCREEN
> + 1;
> > +		ts->early_suspend.suspend = cyttsp_early_suspend;
> > +		ts->early_suspend.resume = cyttsp_late_resume;
> > +		register_early_suspend(&ts->early_suspend);
> > +	}
> > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> 
> As mentioned above I want all the early suspend code to be removed.
> Explore RunTime PM framework of the kernel.
> 

Done.

> > +
> > +	cyttsp_info("Start Probe %s\n", \
> > +		(retval < CY_OK) ? "FAIL" : "PASS");
> > +
> > +	return retval;
> > +}
> > +
> > +/* Function to manage power-on resume */
> > +static int cyttsp_resume(struct i2c_client *client)
> > +{
> > +	struct cyttsp *ts;
> > +	int retval = CY_OK;
> > +
> > +	cyttsp_debug("Wake Up\n");
> > +	ts = (struct cyttsp *) i2c_get_clientdata(client);
> 
> No need of casting.
> 

Fixed.

> > +
> > +	/* re-enable the interrupt prior to wake device */
> > +	if (ts->client->irq)
> > +		enable_irq(ts->client->irq);
> > +
> > +	if (ts->platform_data->use_sleep &&
> > +		(ts->platform_data->power_state != CY_ACTIVE_STATE)) {
> > +		if (ts->platform_data->resume)
> > +			retval = ts->platform_data->resume(client);
> > +		if (!(retval < CY_OK)) {
> > +			retval =
i2c_smbus_read_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(struct cyttsp_bootloader_data_t),
> > +				(u8 *)&g_bl_data);
> > +			if (!(retval < CY_OK) &&
> > +				GET_BOOTLOADERMODE(g_bl_data.bl_status))
{
> > +				u8 tries;
> > +				retval = i2c_smbus_write_i2c_block_data(
> > +					ts->client,
> > +					CY_REG_BASE,
> > +					sizeof(bl_cmd), bl_cmd);
> > +				/* switch back to operational mode */
> > +				tries = 0;
> > +				mdelay(10);
> > +				while
(GET_BOOTLOADERMODE(g_bl_data.bl_status)
> > +					&& tries++ < 10) {
> > +					mdelay(100);
> 
> Do you really need to use mdelay(...) in the resume path? Is there any
> way you could use msleep(..)
> or say no delay at all.
>

Replaced all mdelay with msleep in new code.

> > +					cyttsp_putbl(ts, 16,
> > +						false, false, false);
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	if (!(retval < CY_OK) &&
> > +		(GET_HSTMODE(g_bl_data.bl_file) == CY_OK)) {
> > +		ts->platform_data->power_state = CY_ACTIVE_STATE;
> > +
> > +		/* re-enable the timer after resuming */
> > +		if (ts->client->irq == 0)
> > +			mod_timer(&ts->timer, jiffies +
TOUCHSCREEN_TIMEOUT);
> > +	} else
> > +		retval = -ENODEV;
> > +
> > +	cyttsp_debug("Wake Up %s\n", \
> > +		(retval < CY_OK) ? "FAIL" : "PASS");
> > +
> > +	return retval;
> > +}
> > +
> > +
> > +/* Function to manage low power suspend */
> > +static int cyttsp_suspend(struct i2c_client *client, pm_message_t
> message)
> 
> Please put #ifdef CONFIG_PM around suspend/resume functions.
>

Done.
 
> > +{
> > +	struct cyttsp *ts;
> > +	u8 sleep_mode = CY_OK;
> > +	int retval = CY_OK;
> > +
> > +	cyttsp_debug("Enter Sleep\n");
> > +	ts = (struct cyttsp *) i2c_get_clientdata(client);
> 
> Casting from void * is not required. Please remove.
> 

Done.

> > +
> > +	/* disable worker */
> > +	if (ts->client->irq == 0)
> > +		del_timer(&ts->timer);
> > +	else
> > +		disable_irq_nosync(ts->client->irq);
> > +	retval = cancel_work_sync(&ts->work);
> > +
> > +	if (retval)
> > +		enable_irq(ts->client->irq);
> > +
> > +	if (!(retval < CY_OK)) {
> > +		if (ts->platform_data->use_sleep &&
> > +			(ts->platform_data->power_state ==
CY_ACTIVE_STATE))
> {
> > +			if (ts->platform_data->use_sleep &
> CY_USE_DEEP_SLEEP_SEL)
> > +				sleep_mode = CY_DEEP_SLEEP_MODE;
> > +			else
> > +				sleep_mode = CY_LOW_PWR_MODE;
> > +
> > +			retval =
i2c_smbus_write_i2c_block_data(ts->client,
> > +				CY_REG_BASE,
> > +				sizeof(sleep_mode), &sleep_mode);
> > +		}
> > +	}
> > +
> > +	if (!(retval < CY_OK)) {
> > +		if (sleep_mode == CY_DEEP_SLEEP_MODE)
> > +			ts->platform_data->power_state = CY_SLEEP_STATE;
> > +		else if (sleep_mode == CY_LOW_PWR_MODE)
> > +			ts->platform_data->power_state =
CY_LOW_PWR_STATE;
> > +	}
> > +
> > +	cyttsp_debug("Sleep Power state is %s\n", \
> > +		(ts->platform_data->power_state == CY_ACTIVE_STATE) ? \
> > +		"ACTIVE" : \
> > +		((ts->platform_data->power_state == CY_SLEEP_STATE) ? \
> > +		"SLEEP" : "LOW POWER"));
> > +
> > +	return retval;
> > +}
> > +
> > +/* registered in driver struct */
> > +static int __devexit cyttsp_remove(struct i2c_client *client)
> > +{
> > +	struct cyttsp *ts;
> > +	int err;
> > +
> > +	cyttsp_alert("Unregister\n");
> > +
> > +	/* clientdata registered on probe */
> > +	ts = i2c_get_clientdata(client);
> > +	device_remove_file(&ts->client->dev, &dev_attr_irq_enable);
> > +
> > +	/* Start cleaning up by removing any delayed work and the timer
> */
> > +	if (cancel_delayed_work((struct delayed_work *)&ts->work) <
> CY_OK)
> > +		cyttsp_alert("error: could not remove work from
> workqueue\n");
> > +
> > +	/* free up timer or irq */
> > +	if (ts->client->irq == 0) {
> > +		err = del_timer(&ts->timer);
> > +		if (err < CY_OK)
> > +			cyttsp_alert("error: failed to delete timer\n");
> > +	} else
> > +		free_irq(client->irq, ts);
> > +
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +	unregister_early_suspend(&ts->early_suspend);
> > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> > +
> > +	/* housekeeping */
> > +	if (ts != NULL)
> > +		kfree(ts);
> > +
> > +	cyttsp_alert("Leaving\n");
> 
> I don't removal of input_dev structures.
>

New code has removal code.
 
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > +static void cyttsp_early_suspend(struct early_suspend *handler)
> > +{
> > +	struct cyttsp *ts;
> > +
> > +	ts = container_of(handler, struct cyttsp, early_suspend);
> > +	cyttsp_suspend(ts->client, PMSG_SUSPEND);
> > +}
> > +
> > +static void cyttsp_late_resume(struct early_suspend *handler)
> > +{
> > +	struct cyttsp *ts;
> > +
> > +	ts = container_of(handler, struct cyttsp, early_suspend);
> > +	cyttsp_resume(ts->client);
> > +}
> > +#endif  /* CONFIG_HAS_EARLYSUSPEND */
> > +
> > +static int cyttsp_init(void)
> > +{
> 
> __init
> 

Module_init() used in new code.

> > +	int ret;
> > +
> > +	cyttsp_info("Cypress TrueTouch(R) Standard Product\n");
> > +	cyttsp_info("I2C Touchscreen Driver (Built %s @ %s)\n", \
> > +		__DATE__, __TIME__);
> > +
> > +	cyttsp_ts_wq = create_singlethread_workqueue("cyttsp_ts_wq");
> > +	if (cyttsp_ts_wq == NULL) {
> > +		cyttsp_debug("No memory for cyttsp_ts_wq\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	ret = i2c_add_driver(&cyttsp_driver);
> > +
> > +	return ret;
> > +}
> > +
> > +static void cyttsp_exit(void)
> > +{
> 
> __exit
> 

Module_exit() used in new code.

> > +	if (cyttsp_ts_wq)
> > +		destroy_workqueue(cyttsp_ts_wq);
> > +	return i2c_del_driver(&cyttsp_driver);
> > +}
> > +
> > +module_init(cyttsp_init);
> > +module_exit(cyttsp_exit);
> > +
> > diff --git a/include/linux/cyttsp.h b/include/linux/cyttsp.h
> > new file mode 100644
> > index 0000000..2ab1a5c
> > --- /dev/null
> > +++ b/include/linux/cyttsp.h
> > @@ -0,0 +1,649 @@
> > +/* Header file for:
> > + * Cypress TrueTouch(TM) Standard Product touchscreen drivers.
> > + * include/linux/cyttsp.h
> 
> No file paths please.
> 

Removed in new code.

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
> along
> > + * with this program; if not, write to the Free Software
Foundation,
> Inc.,
> > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > + *
> > + * Cypress reserves the right to make changes without further
notice
> > + * to the materials described herein. Cypress does not assume any
> > + * liability arising out of the application described herein.
> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> > + *
> > + */
> > +
> > +
> > +#ifndef __CYTTSP_H__
> > +#define __CYTTSP_H__
> > +
> > +#include <linux/input.h>
> > +#include <linux/timer.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/kernel.h>
> > +#include <linux/delay.h>
> > +
> > +#define CYPRESS_TTSP_NAME	"cyttsp"
> > +#define CY_I2C_NAME		"cyttsp-i2c"
> > +#define CY_SPI_NAME		"cyttsp-spi"
> 
> I don't think that driver could be easily converted to fit with "spi",
> as I see i2c calls all over.
> 

New refactored code has extracted common code into a core file and added
special I2C only and SPI only files.

> > +
> > +#ifdef CY_DECLARE_GLOBALS
> > +	uint32_t cyttsp_tsdebug;
> > +	module_param_named(tsdebug, cyttsp_tsdebug, uint, 0664);
> > +	uint32_t cyttsp_tsxdebug;
> > +	module_param_named(tsxdebug, cyttsp_tsxdebug, uint, 0664);
> > +
> > +	uint32_t cyttsp_disable_touch;
> > +	module_param_named(disable_touch, cyttsp_disable_touch, uint,
> 0664);
> > +#else
> > +	extern uint32_t cyttsp_tsdebug;
> > +	extern uint32_t cyttsp_tsxdebug;
> > +	extern uint32_t cyttsp_disable_touch;
> > +#endif
> > +
> > +
> > +
> >
>
+/*********************************************************************
> *********
> > + * Global Control, Used to control the behavior of the driver
> > + */
> > +
> > +/* defines for Gen2 (Txx2xx); Gen3 (Txx3xx)
> > + * use these defines to set cyttsp_platform_data.gen in board
config
> file
> > + */
> > +#define CY_GEN2		2
> > +#define CY_GEN3		3
> > +
> > +/* define for using I2C driver
> > + */
> > +#define CY_USE_I2C_DRIVER
> > +
> > +/* defines for using SPI driver */
> > +/*
> > +#define CY_USE_SPI_DRIVER
> > + */
> > +#define CY_SPI_DFLT_SPEED_HZ		1000000
> > +#define CY_SPI_MAX_SPEED_HZ		4000000
> > +#define CY_SPI_SPEED_HZ			CY_SPI_DFLT_SPEED_HZ
> > +#define CY_SPI_BITS_PER_WORD		8
> > +#define CY_SPI_DAV			139	/* set correct gpio id
*/
> > +#define CY_SPI_BUFSIZE			512
> 
> 
> No need of these #defines unless we see driver for SPI.
> 

New code has SPI defines only in SPI file.

> > +
> > +
> > +/* define for inclusion of TTSP App Update Load File
> > + * use this define if update to the TTSP Device is desired
> > + */
> > +/*
> > +#define CY_INCLUDE_LOAD_FILE
> > +*/
> > +
> > +/* define if force new load file for bootloader load */
> > +/*
> > +#define CY_FORCE_FW_UPDATE
> > +*/
> > +
> > +/* undef for production use */
> > +/*
> > + */
> > +#define CY_USE_DEBUG
> 
> As indicated please use kernel dev_dbg/dev_xxx and pr_debug/pr_xxx
> friends.
> 

New code only uses printk() calls.

> > +
> > +/* undef for irq use; use this define in the board configuration
> file */
> > +/*
> > +#define CY_USE_TIMER
> > + */
> 
> As indicated above polling mode should be removed.
> 

Retained to support developers using polling platform models.

> > +
> > +/* undef to allow use of extra debug capability */
> > +/*
> > +#define CY_ALLOW_EXTRA_DEBUG
> > +*/
> > +
> > +/* undef to remove additional debug prints */
> > +/*
> > +#define CY_USE_EXTRA_DEBUG
> > +*/
> > +
> > +/* undef to remove additional debug prints */
> > +/*
> > +#define CY_USE_EXTRA_DEBUG1
> > + */
> > +
> > +/* undef to use operational touch timer jiffies; else use test
> jiffies */
> > +/*
> > +#define CY_USE_TIMER_DEBUG
> > + */
> > +
> > +/* define to use canned test data */
> > +/*
> > +#define CY_USE_TEST_DATA
> > + */
> > +
> > +/* define to activate power management */
> > +/*
> > +#define CY_USE_LOW_POWER
> > + */
> 
> Please see if you can use RunTime PM apis for LPM.
>

Suspend/resume code simplified in new code.
 
> > +
> > +/* define if wake on i2c addr is activated */
> > +/*
> > +#define CY_USE_DEEP_SLEEP
> > + */
> > +
> > +/* define if gesture signaling is used
> > + * and which gesture groups to use
> > + */
> > +/*
> > +#define CY_USE_GEST
> > +#define CY_USE_GEST_GRP1
> > +#define CY_USE_GEST_GRP2
> > +#define CY_USE_GEST_GRP3
> > +#define CY_USE_GEST_GRP4
> > + */
> > +/* Active distance in pixels for a gesture to be reported
> > + * if set to 0, then all gesture movements are reported
> > + */
> > +#define CY_ACT_DIST_DFLT	8
> > +#define CY_ACT_DIST			CY_ACT_DIST_DFLT
> > +
> > +/* define if MT signals are desired */
> > +/*
> > +*/
> > +#define CY_USE_MT_SIGNALS
> > +
> > +/* define if MT tracking id signals are used */
> > +/*
> > +#define CY_USE_MT_TRACK_ID
> > + */
> > +
> > +/* define if ST signals are required */
> > +/*
> > +#define CY_USE_ST_SIGNALS
> > +*/
> > +
> > +/* define to send handshake to device */
> > +/*
> > +#define CY_USE_HNDSHK
> > +*/
> > +
> > +/* define if log all raw motion signals to a sysfs file */
> > +/*
> > +#define CY_LOG_TO_FILE
> > +*/
> > +
> > +
> > +/* End of the Global Control section
> > +
>
***********************************************************************
> *******
> > + */
> > +#define CY_DIFF(m, n)		((m) != (n))
> > +
> > +#ifdef CY_LOG_TO_FILE
> > +	#define cyttsp_openlog()	/* use sysfs */
> > +#else
> > +	#define cyttsp_openlog()
> > +#endif /* CY_LOG_TO_FILE */
> > +
> > +/* see kernel.h for pr_xxx def'ns */
> > +#define cyttsp_info(f, a...)		pr_info("%s:" f,
__func__ ,
> ## a)
> > +#define cyttsp_error(f, a...)		pr_err("%s:" f,
__func__ ,
> ## a)
> > +#define cyttsp_alert(f, a...)		pr_alert("%s:" f,
__func__ ,
> ## a)
> > +
> > +#ifdef CY_USE_DEBUG
> > +	#define cyttsp_debug(f, a...)	pr_alert("%s:" f,  __func__ , ##
a)
> > +#else
> > +	#define cyttsp_debug(f, a...)	{if (cyttsp_tsdebug) \
> > +					pr_alert("%s:" f,  __func__ , ##
a); }
> > +#endif /* CY_USE_DEBUG */
> > +
> > +#ifdef CY_ALLOW_EXTRA_DEBUG
> > +#ifdef CY_USE_EXTRA_DEBUG
> > +	#define cyttsp_xdebug(f, a...)	pr_alert("%s:" f,  __func__ ,
> ## a)
> > +#else
> > +	#define cyttsp_xdebug(f, a...)	{if (cyttsp_tsxdebug) \
> > +					pr_alert("%s:" f,  __func__ , ##
a); }
> > +#endif /* CY_USE_EXTRA_DEBUG */
> > +
> > +#ifdef CY_USE_EXTRA_DEBUG1
> > +	#define cyttsp_xdebug1(f, a...)	pr_alert("%s:" f,  __func__ ,
> ## a)
> > +#else
> > +	#define cyttsp_xdebug1(f, a...)
> > +#endif /* CY_USE_EXTRA_DEBUG1 */
> > +#else
> > +	#define cyttsp_xdebug(f, a...)
> > +	#define cyttsp_xdebug1(f, a...)
> > +#endif /* CY_ALLOW_EXTRA_DEBUG */
> 
> Please remove customized debugs.
> 

Done in new code.

> > +
> > +#ifdef CY_USE_TIMER_DEBUG
> > +	#define	TOUCHSCREEN_TIMEOUT	(msecs_to_jiffies(1000))
> > +#else
> > +	#define	TOUCHSCREEN_TIMEOUT	(msecs_to_jiffies(28))
> > +#endif
> > +
> 
> 
> 
> > +/* reduce extra signals in MT only build
> > + * be careful not to lose backward compatibility for pre-MT apps
> > + */
> > +#ifdef CY_USE_ST_SIGNALS
> > +	#define CY_USE_ST	1
> > +#else
> > +	#define CY_USE_ST	0
> > +#endif /* CY_USE_ST_SIGNALS */
> > +
> > +/* rely on kernel input.h to define Multi-Touch capability */
> > +/* if input.h defines the Multi-Touch signals, then use MT */
> > +#if defined(ABS_MT_TOUCH_MAJOR) && defined(CY_USE_MT_SIGNALS)
> > +	#define CY_USE_MT	1
> > +	#define CY_MT_SYNC(input)	input_mt_sync(input)
> > +#else
> 
> I don't think we need such hacks, as latest kernel supports MT.
> 

Hacks removed from driver code.

> > +	#define CY_USE_MT	0
> > +	#define CY_MT_SYNC(input)
> > +	/* the following includes are provided to ensure a compile;
> > +	 * the code that compiles with these defines will not be
executed
> if
> > +	 * the CY_USE_MT is properly used in the platform structure init
> > +	 */
> > +	#ifndef ABS_MT_TOUCH_MAJOR
> > +	#define ABS_MT_TOUCH_MAJOR	0x30	/* touching ellipse */
> > +	#define ABS_MT_TOUCH_MINOR	0x31	/* (omit if circular) */
> > +	#define ABS_MT_WIDTH_MAJOR	0x32	/* approaching ellipse
*/
> > +	#define ABS_MT_WIDTH_MINOR	0x33	/* (omit if circular) */
> > +	#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation
*/
> > +	#define ABS_MT_POSITION_X	0x35	/* Center X ellipse
position
> */
> > +	#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse
position
> */
> > +	#define ABS_MT_TOOL_TYPE	0x37	/* Type of touching
device */
> > +	#define ABS_MT_BLOB_ID		0x38	/* Group set of pkts as
blob
> */
> > +	#endif /* ABS_MT_TOUCH_MAJOR */
> > +#endif /* ABS_MT_TOUCH_MAJOR and CY_USE_MT_SIGNALS */
> > +#if defined(ABS_MT_TRACKING_ID)  && defined(CY_USE_MT_TRACK_ID)
> > +	#define CY_USE_TRACKING_ID	1
> > +#else
> > +	#define CY_USE_TRACKING_ID	0
> > +/* define only if not defined already by system;
> > + * value based on linux kernel 2.6.30.10
> > + */
> > +#ifndef ABS_MT_TRACKING_ID
> > +	#define ABS_MT_TRACKING_ID	(ABS_MT_BLOB_ID+1)
> > +#endif
> > +#endif /* ABS_MT_TRACKING_ID */
> > +
> > +#ifdef CY_USE_DEEP_SLEEP
> > +	#define CY_USE_DEEP_SLEEP_SEL	0x80
> > +#else
> > +	#define CY_USE_DEEP_SLEEP_SEL	0x00
> > +#endif
> > +#ifdef CY_USE_LOW_POWER
> > +	#define CY_USE_SLEEP	(CY_USE_DEEP_SLEEP_SEL | 0x01)
> > +#else
> > +	#define CY_USE_SLEEP	0x00
> > +#endif /* CY_USE_LOW_POWER */
> > +
> > +#ifdef CY_USE_TEST_DATA
> > +	#define cyttsp_testdat(ray1, ray2, sizeofray) \
> > +		{ \
> > +			int i; \
> > +			u8 *up1 = (u8 *)ray1; \
> > +			u8 *up2 = (u8 *)ray2; \
> > +			for (i = 0; i < sizeofray; i++) { \
> > +				up1[i] = up2[i]; \
> > +			} \
> > +		}
> > +#else
> > +	#define cyttsp_testdat(xy, test_xy, sizeofray)
> > +#endif /* CY_USE_TEST_DATA */
> > +
> > +/* helper macros */
> > +#define GET_NUM_TOUCHES(x)		((x) & 0x0F)
> > +#define GET_TOUCH1_ID(x)		(((x) & 0xF0) >> 4)
> > +#define GET_TOUCH2_ID(x)		((x) & 0x0F)
> > +#define GET_TOUCH3_ID(x)		(((x) & 0xF0) >> 4)
> > +#define GET_TOUCH4_ID(x)		((x) & 0x0F)
> > +#define IS_LARGE_AREA(x)		(((x) & 0x10) >> 4)
> > +#define FLIP_DATA_FLAG			0x01
> > +#define REVERSE_X_FLAG			0x02
> > +#define REVERSE_Y_FLAG			0x04
> > +#define FLIP_DATA(flags)		((flags) & FLIP_DATA_FLAG)
> > +#define REVERSE_X(flags)		((flags) & REVERSE_X_FLAG)
> > +#define REVERSE_Y(flags)		((flags) & REVERSE_Y_FLAG)
> > +#define FLIP_XY(x, y)			{ \
> > +						u16 tmp; \
> > +						tmp = (x); \
> > +						(x) = (y); \
> > +						(y) = tmp; \
> > +					}
> > +#define INVERT_X(x, xmax)		((xmax) - (x))
> > +#define INVERT_Y(y, ymax)		((ymax) - (y))
> > +#define SET_HSTMODE(reg, mode)		((reg) & (mode))
> > +#define GET_HSTMODE(reg)		((reg & 0x70) >> 4)
> > +#define GET_BOOTLOADERMODE(reg)		((reg & 0x10) >> 4)
> > +
> > +/* constant definitions */
> > +/* maximum number of concurrent ST track IDs */
> > +#define CY_NUM_ST_TCH_ID		2
> > +
> > +/* maximum number of concurrent MT track IDs */
> > +#define CY_NUM_MT_TCH_ID		4
> > +
> > +/* maximum number of track IDs */
> > +#define CY_NUM_TRK_ID			16
> > +
> > +#define CY_NTCH				0	/* no touch
(lift off)
> */
> > +#define CY_TCH				1	/* active touch
(touchdown)
> */
> > +#define CY_ST_FNGR1_IDX			0
> > +#define CY_ST_FNGR2_IDX			1
> > +#define CY_MT_TCH1_IDX			0
> > +#define CY_MT_TCH2_IDX			1
> > +#define CY_MT_TCH3_IDX			2
> > +#define CY_MT_TCH4_IDX			3
> > +#define CY_XPOS				0
> > +#define CY_YPOS				1
> > +#define CY_IGNR_TCH			(-1)
> > +#define CY_SMALL_TOOL_WIDTH		10
> > +#define CY_LARGE_TOOL_WIDTH		255
> > +#define CY_REG_BASE			0x00
> > +#define CY_REG_GEST_SET			0x1E
> > +#define CY_REG_ACT_INTRVL		0x1D
> > +#define CY_REG_TCH_TMOUT		(CY_REG_ACT_INTRVL+1)
> > +#define CY_REG_LP_INTRVL		(CY_REG_TCH_TMOUT+1)
> > +#define CY_SOFT_RESET			((1 << 0))
> > +#define CY_DEEP_SLEEP			((1 << 1))
> > +#define CY_LOW_POWER			((1 << 2))
> > +#define CY_MAXZ				255
> > +#define CY_OK				0
> > +#define CY_INIT				1
> > +#define	CY_DLY_DFLT			10	/* ms */
> > +#define CY_DLY_SYSINFO			20	/* ms */
> > +#define CY_DLY_BL			300
> > +#define CY_DLY_DNLOAD			100	/* ms */
> > +#define CY_NUM_RETRY			4	/* max num touch
data read */
> > +
> > +/* handshake bit in the hst_mode reg */
> > +#define CY_HNDSHK_BIT			0x80
> > +#ifdef CY_USE_HNDSHK
> > +	#define CY_SEND_HNDSHK		1
> > +#else
> > +	#define CY_SEND_HNDSHK		0
> > +#endif
> > +
> > +/* Bootloader File 0 offset */
> > +#define CY_BL_FILE0			0x00
> > +
> > +/* Bootloader command directive */
> > +#define CY_BL_CMD			0xFF
> > +
> > +/* Bootloader Initiate Bootload */
> > +#define CY_BL_INIT_LOAD			0x38
> > +
> > +/* Bootloader Write a Block */
> > +#define CY_BL_WRITE_BLK			0x39
> > +
> > +/* Bootloader Terminate Bootload */
> > +#define CY_BL_TERMINATE			0x3B
> > +
> > +/* Bootloader Exit and Verify Checksum command */
> > +#define CY_BL_EXIT			0xA5
> > +
> > +/* Bootloader default keys */
> > +#define CY_BL_KEY0			0x00
> > +#define CY_BL_KEY1			0x01
> > +#define CY_BL_KEY2			0x02
> > +#define CY_BL_KEY3			0x03
> > +#define CY_BL_KEY4			0x04
> > +#define CY_BL_KEY5			0x05
> > +#define CY_BL_KEY6			0x06
> > +#define CY_BL_KEY7			0x07
> > +
> > +/* Active Power state scanning/processing refresh interval */
> > +#define CY_ACT_INTRVL_DFLT		0x00
> > +
> > +/* touch timeout for the Active power */
> > +#define CY_TCH_TMOUT_DFLT		0xFF
> > +
> > +/* Low Power state scanning/processing refresh interval */
> > +#define CY_LP_INTRVL_DFLT		0x0A
> > +
> > +#define CY_IDLE_STATE		0
> > +#define CY_ACTIVE_STATE		1
> > +#define CY_LOW_PWR_STATE		2
> > +#define CY_SLEEP_STATE		3
> > +
> > +/* device mode bits */
> > +#define CY_OP_MODE		0x00
> > +#define CY_SYSINFO_MODE		0x10
> > +
> > +/* power mode select bits */
> > +#define CY_SOFT_RESET_MODE		0x01	/* return to Bootloader
mode
> */
> > +#define CY_DEEP_SLEEP_MODE		0x02
> > +#define CY_LOW_PWR_MODE		0x04
> > +
> > +#define CY_NUM_KEY			8
> > +
> > +#ifdef CY_USE_GEST
> > +	#define CY_USE_GESTURES	1
> > +#else
> > +	#define CY_USE_GESTURES	0
> > +#endif /* CY_USE_GESTURE_SIGNALS */
> > +
> > +#ifdef CY_USE_GEST_GRP1
> > +	#define CY_GEST_GRP1	0x10
> > +#else
> > +	#define CY_GEST_GRP1	0x00
> > +#endif	/* CY_USE_GEST_GRP1 */
> > +#ifdef CY_USE_GEST_GRP2
> > +	#define CY_GEST_GRP2	0x20
> > +#else
> > +	#define CY_GEST_GRP2	0x00
> > +#endif	/* CY_USE_GEST_GRP2 */
> > +#ifdef CY_USE_GEST_GRP3
> > +	#define CY_GEST_GRP3	0x40
> > +#else
> > +	#define CY_GEST_GRP3	0x00
> > +#endif	/* CY_USE_GEST_GRP3 */
> > +#ifdef CY_USE_GEST_GRP4
> > +	#define CY_GEST_GRP4	0x80
> > +#else
> > +	#define CY_GEST_GRP4	0x00
> > +#endif	/* CY_USE_GEST_GRP4 */
> > +
> > +
> > +struct cyttsp_platform_data {
> > +	u32 maxx;
> > +	u32 maxy;
> > +	u32 flags;
> > +	u8 gen;
> > +	u8 use_st;
> > +	u8 use_mt;
> > +	u8 use_hndshk;
> > +	u8 use_trk_id;
> > +	u8 use_sleep;
> > +	u8 use_gestures;
> > +	u8 gest_set;
> > +	u8 act_intrvl;
> > +	u8 tch_tmout;
> > +	u8 lp_intrvl;
> > +	u8 power_state;
> > +#ifdef CY_USE_I2C_DRIVER
> > +	s32 (*init)(struct i2c_client *client);
> > +	s32 (*resume)(struct i2c_client *client);
> > +#endif
> > +#ifdef CY_USE_SPI_DRIVER
> > +	s32 (*init)(struct spi_device *spi);
> > +	s32 (*resume)(struct spi_device *spi);
> > +#endif
> > +};
> > +
> > +/* TrueTouch Standard Product Gen3 (Txx3xx) interface definition */
> > +struct cyttsp_gen3_xydata_t {
> > +	u8 hst_mode;
> > +	u8 tt_mode;
> > +	u8 tt_stat;
> > +	u16 x1 __attribute__ ((packed));
> > +	u16 y1 __attribute__ ((packed));
> > +	u8 z1;
> > +	u8 touch12_id;
> > +	u16 x2 __attribute__ ((packed));
> > +	u16 y2 __attribute__ ((packed));
> > +	u8 z2;
> > +	u8 gest_cnt;
> > +	u8 gest_id;
> > +	u16 x3 __attribute__ ((packed));
> > +	u16 y3 __attribute__ ((packed));
> > +	u8 z3;
> > +	u8 touch34_id;
> > +	u16 x4 __attribute__ ((packed));
> > +	u16 y4 __attribute__ ((packed));
> > +	u8 z4;
> > +	u8 tt_undef[3];
> > +	u8 gest_set;
> > +	u8 tt_reserved;
> > +};
> 
> Do you really need this to be exported in the header file? If possible
> move it to the .c file.
> 

This has been done in the new refactored code.

> > +
> > +/* TrueTouch Standard Product Gen2 (Txx2xx) interface definition */
> > +#define CY_GEN2_NOTOUCH		0x03	/* Both touches removed
*/
> > +#define CY_GEN2_GHOST		0x02	/* ghost */
> > +#define CY_GEN2_2TOUCH		0x03	/* 2 touch; no ghost */
> > +#define CY_GEN2_1TOUCH		0x01	/* 1 touch only */
> > +#define CY_GEN2_TOUCH2		0x01	/* 1st touch removed;
> > +						 * 2nd touch remains */
> > +struct cyttsp_gen2_xydata_t {
> > +	u8 hst_mode;
> > +	u8 tt_mode;
> > +	u8 tt_stat;
> > +	u16 x1 __attribute__ ((packed));
> > +	u16 y1 __attribute__ ((packed));
> > +	u8 z1;
> > +	u8 evnt_idx;
> > +	u16 x2 __attribute__ ((packed));
> > +	u16 y2 __attribute__ ((packed));
> > +	u8 tt_undef1;
> > +	u8 gest_cnt;
> > +	u8 gest_id;
> > +	u8 tt_undef[14];
> > +	u8 gest_set;
> > +	u8 tt_reserved;
> > +};
> > +
> > +/* TTSP System Information interface definition */
> > +struct cyttsp_sysinfo_data_t {
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
> > +	u8 tt_undef[6];
> > +	u8 act_intrvl;
> > +	u8 tch_tmout;
> > +	u8 lp_intrvl;
> > +};
> 
> Ditto.
> 
> > +
> > +/* TTSP Bootloader Register Map interface definition */
> > +#define CY_BL_CHKSUM_OK		0x01
> > +struct cyttsp_bootloader_data_t {
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
> > +#define cyttsp_wake_data_t		cyttsp_gen3_xydata_t
> > +#ifdef CY_DECLARE_GLOBALS
> > +	#ifdef CY_INCLUDE_LOAD_FILE
> > +		/* this file declares:
> > +		 * firmware download block array (cyttsp_fw[]),
> > +		 * the number of command block records
(cyttsp_fw_records),
> > +		 * and the version variables
> > +		 */
> > +		#include "cyttsp_fw.h"		/* imports cyttsp_fw[]
array
> */
> > +		#define cyttsp_app_load()	1
> > +		#ifdef CY_FORCE_FW_UPDATE
> > +			#define cyttsp_force_fw_load()	1
> > +		#else
> > +			#define cyttsp_force_fw_load()	0
> > +		#endif
> > +
> > +	#else
> > +		/* the following declarations are to allow
> > +		 * some debugging capability
> > +		 */
> > +		unsigned char cyttsp_fw_tts_verh = 0x00;
> > +		unsigned char cyttsp_fw_tts_verl = 0x01;
> > +		unsigned char cyttsp_fw_app_idh = 0x02;
> > +		unsigned char cyttsp_fw_app_idl = 0x03;
> > +		unsigned char cyttsp_fw_app_verh = 0x04;
> > +		unsigned char cyttsp_fw_app_verl = 0x05;
> > +		unsigned char cyttsp_fw_cid_0 = 0x06;
> > +		unsigned char cyttsp_fw_cid_1 = 0x07;
> > +		unsigned char cyttsp_fw_cid_2 = 0x08;
> > +		#define cyttsp_app_load()	0
> > +		#define cyttsp_force_fw_load()	0
> > +	#endif
> > +	#define cyttsp_tts_verh()	cyttsp_fw_tts_verh
> > +	#define cyttsp_tts_verl()	cyttsp_fw_tts_verl
> > +	#define cyttsp_app_idh()	cyttsp_fw_app_idh
> > +	#define cyttsp_app_idl()	cyttsp_fw_app_idl
> > +	#define cyttsp_app_verh()	cyttsp_fw_app_verh
> > +	#define cyttsp_app_verl()	cyttsp_fw_app_verl
> > +	#define cyttsp_cid_0()		cyttsp_fw_cid_0
> > +	#define cyttsp_cid_1()		cyttsp_fw_cid_1
> > +	#define cyttsp_cid_2()		cyttsp_fw_cid_2
> > +	#ifdef CY_USE_TEST_DATA
> > +		static struct cyttsp_gen2_xydata_t tt_gen2_testray[] = {
> > +		{0x00}, {0x00}, {0x04},
> > +		{0x4000}, {0x8000}, {0x80},
> > +		{0x03},
> > +		{0x2000}, {0x1000}, {0x00},
> > +		{0x00},
> > +		{0x00},
> > +		{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +		 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
> > +		{0x00},
> > +		{0x00}
> > +		};
> > +
> > +		static struct cyttsp_gen3_xydata_t tt_gen3_testray[] = {
> > +		{0x00}, {0x00}, {0x04},
> > +		{0x4000}, {0x8000}, {0x80},
> > +		{0x12},
> > +		{0x2000}, {0x1000}, {0xA0},
> > +		{0x00}, {0x00},
> > +		{0x8000}, {0x4000}, {0xB0},
> > +		{0x34},
> > +		{0x4000}, {0x1000}, {0xC0},
> > +		{0x00, 0x00, 0x00},
> > +		{0x00},
> > +		{0x00}
> > +		};
> > +	#endif /* CY_USE_TEST_DATA */
> > +
> > +#else
> > +		extern u8 g_appload_ray[];
> > +#endif
> > +
> > +#endif /* __CYTTSP_H__ */
> 
> ---Trilok Soni
> 
> 
> --
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum.

Thank you Trilok for your review.



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

