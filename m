Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0HDRc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:32:57 -0400
Received: from ns1.cypress.com ([157.95.67.4]:41702 "EHLO ns1.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0HDRcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:32:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Date: Wed, 4 Aug 2010 10:27:06 -0700
Message-ID: <FB9C2CB29A07AB45B575A4E8D2AABC09C48182@labamba.mis.cypress.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
Thread-Index: AcsiYNMRdRJHEHfKQJuy6mTzwkLu7ARmMuYw
References: <kev@cypress.com> <1278968210-6827-1-git-send-email-kev@cypress.com> <4C3C1654.9010204@codeaurora.org> <20100713075544.GA16013@core.coreip.homeip.net>
From: "Kevin McNeely" <Kevin.McNeely@cypress.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Trilok Soni" <tsoni@codeaurora.org>
Cc: "David Brown" <davidb@codeaurora.org>,
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
X-OriginalArrivalTime: 04 Aug 2010 17:27:08.0048 (UTC) FILETIME=[43AD9100:01CB33FA]
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,


> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, July 13, 2010 12:56 AM
> To: Trilok Soni
> Cc: Kevin McNeely; David Brown; Fred; Samuel Ortiz; Eric Miao; Mark
> Brown; Simtec Linux Team; Arnaud Patard; Antonio Ospite; Henrik
> Rydberg; linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-i2c@vger.kernel.org; khali@linux-fr.org; linux-arm-
> msm@vger.kernel.org
> Subject: Re: [PATCH] i2c: cyttsp i2c touchscreen driver init submit
> 
> On Tue, Jul 13, 2010 at 01:01:32PM +0530, Trilok Soni wrote:
> > Hi Kevin,
> >
> > Thanks for posting this driver.
> >
> > Adding Jean Delvar for i2c bits.
> >
> > On 7/13/2010 2:26 AM, Kevin McNeely wrote:
> > > From: Fred <fwk@ubuntu.linuxcertified.com>
> >
> > E-mail id looks wrong. Do you mean fwk@cypress.com?
> >
> > >
> > > This is a new touchscreen driver for the Cypress Semiconductor
> > > cyttsp family of devices.  This driver is for the i2c version
> > > of cyttsp parts.
> >
> > Please explain in commit text which exact version of the chips this
> driver is supporting.
> > It is hard to make out that from this text.
> > >
> > > Signed-off-by: Kevin McNeely <kev@cypress.com>
> > > ---
> > >  drivers/input/touchscreen/Kconfig      |   13 +
> > >  drivers/input/touchscreen/Makefile     |    1 +
> > >  drivers/input/touchscreen/cyttsp-i2c.c | 2016
> ++++++++++++++++++++++++++++++++
> > >  include/linux/cyttsp.h                 |  649 ++++++++++
> >
> > Please move this file to include/linux/input directory.
> >
> 
> Or even keep it in drivers/input/touchscreen/
> 

The cyttsp.h file has been reduced to only information required by board
configuration files.

> >
> > >
> > > diff --git a/drivers/input/touchscreen/Kconfig
> b/drivers/input/touchscreen/Kconfig
> > > index 3b9d5e2..a7a69a0 100644
> > > --- a/drivers/input/touchscreen/Kconfig
> > > +++ b/drivers/input/touchscreen/Kconfig
> > > @@ -603,4 +603,17 @@ config TOUCHSCREEN_TPS6507X
> > >  	  To compile this driver as a module, choose M here: the
> > >  	  module will be called tps6507x_ts.
> > >
> > > +config TOUCHSCREEN_CYTTSP_I2C
> > > +	default n
> >
> > Do we need to provide this if it is no by default?
> >
> > > +	tristate "Cypress TTSP i2c touchscreen"
> > > +	depends on I2C
> > > +	help
> > > +	  Say Y here if you have a Cypress TTSP touchscreen
> > > +	  connected to your system's i2c bus.
> >
> > What is TTSP?
> >
> > > +
> > > +	  If unsure, say N.
> > > +
> > > +	  To compile this driver as a module, choose M here: the
> > > +	  module will be called cyttsp_i2c.
> > > +
> > >  endif
> >
> 
> Since there is SPI part should we prepare for the support and split
> bus-independent parts off? Are you working on SPI support?
> 

This has been done in refactored code that I will submit.
The new code has common code core file and separate I2C and SPI
specific files.  Core and I2C/SPI code will be part of next submission.

> >
> > > diff --git a/drivers/input/touchscreen/cyttsp-i2c.c
> b/drivers/input/touchscreen/cyttsp-i2c.c
> > > new file mode 100644
> > > index 0000000..8397aa1
> > > --- /dev/null
> > > +++ b/drivers/input/touchscreen/cyttsp-i2c.c
> > > @@ -0,0 +1,2016 @@
> > > +/* Source for:
> > > + * Cypress TrueTouch(TM) Standard Product I2C touchscreen driver.
> > > + * drivers/input/touchscreen/cyttsp-i2c.c
> >
> > No file paths please. Already commented on it by Christoph.
> >
> > > + *
> > > + * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * version 2, and only version 2, as published by the
> > > + * Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be
useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public
> License along
> > > + * with this program; if not, write to the Free Software
> Foundation, Inc.,
> > > + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
> > > + *
> > > + * Cypress reserves the right to make changes without further
> notice
> > > + * to the materials described herein. Cypress does not assume any
> > > + * liability arising out of the application described herein.
> > > + *
> > > + * Contact Cypress Semiconductor at www.cypress.com
> >
> > I would like Dmitry to comment on it. Dmitry?
> >
> 
> Not a lwayer but I do not really see an issue here. It is still GPL
and
> they as copyright holders obviously can modify the code. What exactly
> troubles you here?
> 
> 

This paragraph has been removed from headers.


> > > + *
> > > + */
> > > +
> > > +#include <linux/delay.h>
> > > +#include <linux/init.h>
> > > +#include <linux/module.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/input.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/gpio.h>
> > > +#include <linux/irq.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/timer.h>
> > > +#include <linux/workqueue.h>
> > > +#include <linux/byteorder/generic.h>
> > > +#include <linux/bitops.h>
> > > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > > +#include <linux/earlysuspend.h>
> > > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> >
> > We don't have early suspend support yet into the mainline kernel.
> Please remove this code from the driver.
> >
> > > +
> > > +#define CY_DECLARE_GLOBALS
> >
> > Could you please explain what it does?
> >
> > > +
> > > +#include <linux/cyttsp.h>
> > > +
> > > +uint32_t cyttsp_tsdebug1 = 0xff;
> > > +module_param_named(tsdebug1, cyttsp_tsdebug1, uint, 0664);
> > > +
> > > +/* CY TTSP I2C Driver private data */
> > > +struct cyttsp {
> > > +	struct i2c_client *client;
> > > +	struct input_dev *input;
> > > +	struct work_struct work;
> > > +	struct timer_list timer;
> > > +	struct mutex mutex;
> > > +	char phys[32];
> > > +	struct cyttsp_platform_data *platform_data;
> > > +	u8 num_prv_st_tch;
> > > +	u16 act_trk[CY_NUM_TRK_ID];
> > > +	u16 prv_st_tch[CY_NUM_ST_TCH_ID];
> > > +	u16 prv_mt_tch[CY_NUM_MT_TCH_ID];
> > > +	u16 prv_mt_pos[CY_NUM_TRK_ID][2];
> > > +	atomic_t irq_enabled;
> > > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > > +	struct early_suspend early_suspend;
> > > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> > > +};
> > > +static u8 irq_cnt;		/* comparison counter with
register valuw
> */
> >
> > s/valuw/value
> >
> > > +static u32 irq_cnt_total;	/* total interrupts */
> > > +static u32 irq_err_cnt;		/* count number of touch
interrupts
> with err */
> > > +#define CY_IRQ_CNT_MASK	0x000000FF	/* mapped for sizeof
count in
> reg */
> > > +#define CY_IRQ_CNT_REG	0x00		/* tt_undef[0]=reg 0x1B
-
> Gen3 only */
> > > +
> > > +#ifdef CONFIG_HAS_EARLYSUSPEND
> > > +static void cyttsp_early_suspend(struct early_suspend *handler);
> > > +static void cyttsp_late_resume(struct early_suspend *handler);
> > > +#endif /* CONFIG_HAS_EARLYSUSPEND */
> > > +
> > > +static struct workqueue_struct *cyttsp_ts_wq;
> >
> > Why there are so many global variables lying around?
> >
> > > +
> > > +
> > > +/*
>
***********************************************************************
> *****
> > > + * Prototypes for static functions
> > > + *
>
***********************************************************************
> *** */
> > > +static void cyttsp_xy_worker(struct work_struct *work);
> > > +static irqreturn_t cyttsp_irq(int irq, void *handle);
> > > +static int cyttsp_inlist(u16 prev_track[],
> > > +			u8 cur_trk_id, u8 *prev_loc, u8 num_touches);
> > > +static int cyttsp_next_avail_inlist(u16 cur_trk[],
> > > +			u8 *new_loc, u8 num_touches);
> > > +static int cyttsp_putbl(struct cyttsp *ts, int show,
> > > +			int show_status, int show_version, int
show_cid);
> > > +static int __devinit cyttsp_probe(struct i2c_client *client,
> > > +			const struct i2c_device_id *id);
> > > +static int __devexit cyttsp_remove(struct i2c_client *client);
> > > +static int cyttsp_resume(struct i2c_client *client);
> > > +static int cyttsp_suspend(struct i2c_client *client, pm_message_t
> message);
> >
> > Please re-order the functions in the driver such a way so that you
> don't need have these prototypes here.
> >
> > > +
> > > +/* Static variables */
> > > +static struct cyttsp_gen3_xydata_t g_xy_data;
> > > +static struct cyttsp_bootloader_data_t g_bl_data;
> > > +static struct cyttsp_sysinfo_data_t g_sysinfo_data;
> >
> > again globals?
> >
> > > +static const struct i2c_device_id cyttsp_id[] = {
> > > +	{ CY_I2C_NAME, 0 },  { }
> >
> > Why dont you put ,{} at the next line.
> >
> > > +};
> >
> > You should not put driver name above, but it should be something
like
> real chip name.
> >
> > Say cy8ctXXX.
> >
> > > +static u8 bl_cmd[] = {
> > > +	CY_BL_FILE0, CY_BL_CMD, CY_BL_EXIT,
> > > +	CY_BL_KEY0, CY_BL_KEY1, CY_BL_KEY2,
> > > +	CY_BL_KEY3, CY_BL_KEY4, CY_BL_KEY5,
> > > +	CY_BL_KEY6, CY_BL_KEY7};
> >
> > and what these keys does?
> >
> > > +
> > > +MODULE_DEVICE_TABLE(i2c, cyttsp_id);
> >
> > Why it is not with cyttsp_id above?
> >
> > > +
> > > +static struct i2c_driver cyttsp_driver = {
> > > +	.driver = {
> > > +		.name = CY_I2C_NAME,
> > > +		.owner = THIS_MODULE,
> > > +	},
> > > +	.probe = cyttsp_probe,
> > > +	.remove = __devexit_p(cyttsp_remove),
> > > +	.suspend = cyttsp_suspend,
> > > +	.resume = cyttsp_resume,
> > > +	.id_table = cyttsp_id,
> > > +};
> > > +
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen
> driver");
> > > +MODULE_AUTHOR("Cypress");
> >
> > MODULE_ALIAS?
> >
> > > +
> > > +static ssize_t cyttsp_irq_status(struct device *dev,
> > > +				struct device_attribute *attr, char
*buf)
> > > +{
> > > +	struct i2c_client *client = container_of(dev, struct i2c_client,
> dev);
> > > +	struct cyttsp *ts = i2c_get_clientdata(client);
> > > +	return sprintf(buf, "%u\n", atomic_read(&ts->irq_enabled));
> > > +}
> > > +
> > > +static ssize_t cyttsp_irq_enable(struct device *dev,
> > > +				struct device_attribute *attr,
> > > +				const char *buf, size_t size)
> > > +{
> > > +	struct i2c_client *client = container_of(dev, struct i2c_client,
> dev);
> > > +	struct cyttsp *ts = i2c_get_clientdata(client);
> > > +	int err = 0;
> > > +	unsigned long value;
> > > +
> > > +	if (size > 2)
> > > +		return -EINVAL;
> > > +
> > > +	err = strict_strtoul(buf, 10, &value);
> > > +	if (err != 0)
> > > +		return err;
> > > +
> > > +	switch (value) {
> > > +	case 0:
> > > +		if (atomic_cmpxchg(&ts->irq_enabled, 1, 0)) {
> > > +			pr_info("touch irq disabled!\n");
> > > +			disable_irq_nosync(ts->client->irq);
> 
> I do not believe that this achieves what you want.., You may
reschedule
> between cmpxchg and disable_irq_nosync().
> 

This code has been removed from new code to be submitted.

> 
> Haven't looked any further yet...
> 
> --
> Dmitry

Thank you Dmitry for your review.



---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

