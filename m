Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab1EWSnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:43:09 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:18160 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab1EWSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:43:05 -0400
From: KY Srinivasan <kys@microsoft.com>
To: john stultz <johnstul@us.ibm.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hch@infradead.org" <hch@infradead.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Topic: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
Thread-Index: AQHMGW2o73xBkI9IxkSJtOUc7B8Bm5SbNEGA//+K7rA=
Date: Mon, 23 May 2011 18:43:02 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC8C6@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com>
 <1306176027.2968.5.camel@work-vm>
In-Reply-To: <1306176027.2968.5.camel@work-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4NIhHvB029717



> -----Original Message-----
> From: john stultz [mailto:johnstul@us.ibm.com]
> Sent: Monday, May 23, 2011 2:40 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; tglx@linutronix.de; hch@infradead.org; Hank
> Janssen; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver out
> of staging
> 
> On Mon, 2011-05-23 at 10:12 -0700, K. Y. Srinivasan wrote:
> > Move the Hyper-V clocksource driver out of staging.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/clocksource/Makefile        |    1 +
> >  drivers/clocksource/hv_timesource.c |  102
> +++++++++++++++++++++++++++++++++++
> >  drivers/staging/hv/Makefile         |    2 +-
> >  drivers/staging/hv/hv_timesource.c  |  102 -----------------------------------
> >  4 files changed, 104 insertions(+), 103 deletions(-)
> >  create mode 100644 drivers/clocksource/hv_timesource.c
> >  delete mode 100644 drivers/staging/hv/hv_timesource.c
> >
> > diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
> > index be61ece..ea44327 100644
> > --- a/drivers/clocksource/Makefile
> > +++ b/drivers/clocksource/Makefile
> > @@ -6,3 +6,4 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-
> clockevt.o
> >  obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
> >  obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
> >  obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
> > +obj-$(CONFIG_HYPERV)		+= hv_timesource.o
> > diff --git a/drivers/clocksource/hv_timesource.c
> b/drivers/clocksource/hv_timesource.c
> > new file mode 100644
> > index 0000000..0efb049
> > --- /dev/null
> > +++ b/drivers/clocksource/hv_timesource.c
> > @@ -0,0 +1,102 @@
> > +/*
> > + * A clocksource for Linux running on HyperV.
> > + *
> > + *
> > + * Copyright (C) 2010, Novell, Inc.
> > + * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE
> or
> > + * NON INFRINGEMENT.  See the GNU General Public License for more
> > + * details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
> > + *
> > + */
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/version.h>
> > +#include <linux/clocksource.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/dmi.h>
> > +#include <asm/hyperv.h>
> > +#include <asm/mshyperv.h>
> > +#include <asm/hypervisor.h>
> > +
> > +#define HV_CLOCK_SHIFT	22
> > +
> > +static cycle_t read_hv_clock(struct clocksource *arg)
> > +{
> > +	cycle_t current_tick;
> > +	/*
> > +	 * Read the partition counter to get the current tick count. This count
> > +	 * is set to 0 when the partition is created and is incremented in
> > +	 * 100 nanosecond units.
> > +	 */
> > +	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> > +	return current_tick;
> > +}
> > +
> > +static struct clocksource hyperv_cs = {
> > +	.name           = "hyperv_clocksource",
> > +	.rating         = 400, /* use this when running on Hyperv*/
> > +	.read           = read_hv_clock,
> > +	.mask           = CLOCKSOURCE_MASK(64),
> > +	/*
> > +	 * The time ref counter in HyperV is in 100ns units.
> > +	 * The definition of mult is:
> > +	 * mult/2^shift = ns/cyc = 100
> > +	 * mult = (100 << shift)
> > +	 */
> > +	.mult           = (100 << HV_CLOCK_SHIFT),
> > +	.shift          = HV_CLOCK_SHIFT,
> 
> The mult/shift assignments can be dropped. Please use
> clocksource_register_hz/khz() which will assign mult/shift for you.
> 
> Otherwise it looks pretty straightforward.

Will do; thanks.
> 
> 
> > +module_init(init_hv_clocksource);
> > +MODULE_DESCRIPTION("HyperV based clocksource");
> > +MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
> > +MODULE_LICENSE("GPL");
> 
> One other nit: Should this email address be updated to your current one?

I will update it.

Regards,

K. Y

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
