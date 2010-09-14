Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0INBYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 21:24:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11935 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0INBYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 21:24:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Mon, 13 Sep 2010 18:24:37 -0700
From: Gary King <GKing@nvidia.com>
To: Mike Rapoport <mike@compulab.co.il>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Sep 2010 18:24:38 -0700
Subject: Re: [PATCH v2] mfd: tps6586x: add basic interrupt support
Thread-Topic: [PATCH v2] mfd: tps6586x: add basic interrupt support
Thread-Index: ActTq5gKygDcgKzyRKGxYWky4zBbgw==
Message-ID: <4C8ECED6.9030209@nvidia.com>
References: <1283890548-29442-1-git-send-email-gking@nvidia.com>
 <4C8C88DD.5070406@compulab.co.il>
In-Reply-To: <4C8C88DD.5070406@compulab.co.il>
Reply-To: Gary King <GKing@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12)
 Gecko/20100824 Lightning/1.0b1 Thunderbird/3.0.7
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/12/2010 01:01 AM, Mike Rapoport wrote:
>
> Hi Gary,
>
> Gary King wrote:
> > Hi Samuel, Mike,
> >
> > This patch incorporates Mike Rapoport's feedback on my initial patch
> > to add interrupt support to the tps6586x driver.
>
> Overall looks good to me, two nitpicking comments though.
>
> > Changes since v1:
> >
> > * Move the interrupt enum ordering to match the ACK register values
> >
> > * Treat the INT_ACK registers as a single 32b unsigned int.
> >
> > * Name and define all the interrupts on the device
> >
> > * If reading the ACK registers in the interrupt thread fails, IRQ_NONE
> >   is returned, rather than disabling the IRQ handler. This fixes
> >   interrupts following suspend.
> >
> > * The cascaded IRQ is passed through the i2c_client's .irq field, rather
> >   than through platform data.
> >
> > --
> > From bf2f95da6f192e091d9ac0b30c186050aa5fd4e5 Mon Sep 17 00:00:00 2001
> > From: Gary King <gking@nvidia.com>
> > Date: Mon, 30 Aug 2010 16:16:55 -0700
> > Subject: mfd: tps6586x: add basic interrupt support
> >
> > add support for enabling and disabling tps6586x subdevice interrupts,
> > and add support for the RTC interrupts
>
> I think the "add support for the RTC interrupts" is not relevant anymore
>

Oops, I meant to delete that.

> > Signed-off-by: Gary King <gking@nvidia.com>
> > ---
> >  drivers/mfd/tps6586x.c       |  202 
> ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/tps6586x.h |   31 +++++++
> >  2 files changed, 233 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> > index 4cde31e..626081c 100644
> > --- a/drivers/mfd/tps6586x.c
> > +++ b/drivers/mfd/tps6586x.c
> > @@ -15,6 +15,8 @@
> >   * published by the Free Software Foundation.
> >   */
> >
> > +#include <linux/interrupt.h>
> > +#include <linux/irq.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
>
> [ snip ]
>
> >  struct tps6586x_subdev_info {
> >       int             id;
> >       const char      *name;
> > @@ -29,6 +59,7 @@ struct tps6586x_platform_data {
> >       struct tps6586x_subdev_info *subdevs;
> >
> >       int gpio_base;
> > +     int irq_base;
>
> not needed anymore
>

This is still used; it is passed as the irq_base parameter to 
tps6586x_irq_init.

I will send out a v3 that fixes the commit message.

- Gary
