Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0HDQfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:35:16 -0400
Received: from ns2.cypress.com ([157.95.67.5]:41327 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab0HDQfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:35:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Date: Wed, 4 Aug 2010 09:30:54 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C4814C@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Thread-Index: AcsiM7JrRbycyfJNR6GEOIdfSFwESQRvCf4w
References: <Kevin McNeely <kev@cypress.com> <1278968210-6827-1-git-send-email-kev@cypress.com> <1278988464.4037.9.camel@lovely.krouter>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Christoph Fritz" <chf.fritz@googlemail.com>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "David Brown" <davidb@codeaurora.org>,
        "Trilok Soni" <tsoni@codeaurora.org>,
        "Fred" <fwk@ubuntu.linuxcertified.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Eric Miao" <eric.y.miao@gmail.com>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Simtec Linux Team" <linux@simtec.co.uk>,
        "Arnaud Patard" <arnaud.patard@rtp-net.org>,
        "Antonio Ospite" <ospite@studenti.unina.it>,
        "Henrik Rydberg" <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Aug 2010 16:30:55.0630 (UTC) FILETIME=[698F6AE0:01CB33F2]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,


> -----Original Message-----
> From: Christoph Fritz [mailto:chf.fritz@googlemail.com]
> Sent: Monday, July 12, 2010 7:34 PM
> To: Kevin McNeely
> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Fred; Samuel Ortiz;
Eric
> Miao; Mark Brown; Simtec Linux Team; Arnaud Patard; Antonio Ospite;
> Henrik Rydberg; linux-input@vger.kernel.org; linux-
> kernel@vger.kernel.org; chf.fritz@googlemail.com
> Subject: Re: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
> 
> On Mon, 2010-07-12 at 13:56 -0700, Kevin McNeely wrote:
> > From: Fred <fwk@ubuntu.linuxcertified.com>
> >
> > This is a new touchscreen driver for the Cypress Semiconductor
> > cyttsp family of devices.  This driver is for the i2c version
> > of cyttsp parts.
> >
> > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > ---
> >  drivers/input/touchscreen/Kconfig      |   13 +
> >  drivers/input/touchscreen/Makefile     |    1 +
> >  drivers/input/touchscreen/cyttsp-i2c.c | 2016
> ++++++++++++++++++++++++++++++++
> >  include/linux/cyttsp.h                 |  649 ++++++++++
> >  4 files changed, 2679 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/input/touchscreen/cyttsp-i2c.c
> >  create mode 100644 include/linux/cyttsp.h
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
> > +	tristate "Cypress TTSP i2c touchscreen"
> > +	depends on I2C
> > +	help
> > +	  Say Y here if you have a Cypress TTSP touchscreen
> > +	  connected to your system's i2c bus.
> > +
> > +	  If unsure, say N.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called cyttsp_i2c.
> 
> below it's named cyttsp-i2c

This will be fixed.

> 
> > +
> >  endif
> > diff --git a/drivers/input/touchscreen/Makefile
> b/drivers/input/touchscreen/Makefile
> > index 497964a..2026cb8 100644
> > --- a/drivers/input/touchscreen/Makefile
> > +++ b/drivers/input/touchscreen/Makefile
> > @@ -47,3 +47,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)
+=
> mainstone-wm97xx.o
> >  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
> >  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
> > +obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp-i2c.o
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
> To quote Dmitry Torokhov:
> "No file names  (and especially paths) in comment blocks please -
makes
> harder to move stuff around."
> 

Paths and filenames will be removed from the headers.

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
> 
> Sure, Cypress can engineer what they want. The warranty is already
> covered by GPL.
> 

The paragraph will be removed from the headers.


> > + *
> > + * Contact Cypress Semiconductor at www.cypress.com
> 
> Maintainer or at least a email ad would be nice I think.
> 

An email address will be added to the headers.

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
> > +
> > +#define CY_DECLARE_GLOBALS
> > +
> > +#include <linux/cyttsp.h>
> 
> Would it be possible to move cyttsp.h to the local folder?
> 

The cyttsp.h file needs to be in the global folder to support board
configuration files.  The cyttsp.h contents will be reduced to the
minimum and a local include file will be added.


> > +
> > +uint32_t cyttsp_tsdebug1 = 0xff;
> 
> why can't this be static?
> why is it in the header too?
> 

Globals and statics will be removed.  Data will either be in context
structure or automatic.

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
> 
> star gap, and more than 80 chars
> 

New code will not have lines greater than 80 chars.

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
> could these prototypes be avoided?
> 

Prototypes will be removed by reordering functions.

> > +
> > +/* Static variables */
> > +static struct cyttsp_gen3_xydata_t g_xy_data;
> > +static struct cyttsp_bootloader_data_t g_bl_data;
> > +static struct cyttsp_sysinfo_data_t g_sysinfo_data;
> > +static const struct i2c_device_id cyttsp_id[] = {
> > +	{ CY_I2C_NAME, 0 },  { }
> > +};
> > +static u8 bl_cmd[] = {
> > +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> > +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> > +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> > +	CY_BL_KEY6, CY_BL_KEY7};
> > +
> > +MODULE_DEVICE_TABLE(i2c, cyttsp_id);
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
> Why not re-factoring the whole driver to keep consistency with other
> touchpad drivers?


The new code will be refactored.

> A maintainer to contact or at least a email-ad would be nice I think.
> You could use scripts/checkpatch.pl to find some warnings.
> 
> [..]
> 

The new code will have an email address and will be scanned with
checkpatch.

Thank you Christopher for your review.


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

