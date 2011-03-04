Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab1CDI7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:59:12 -0500
Received: from mail.perches.com ([173.55.12.10]:4108 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758400Ab1CDI6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:58:47 -0500
Subject: Re: [PATCH 1/2] MAX8997/8966 MFD: Add IRQ control feature
From: Joe Perches <joe@perches.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
In-Reply-To: <1299224747-11081-1-git-send-email-myungjoo.ham@samsung.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
	 <1299224747-11081-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 00:58:45 -0800
Message-ID: <1299229125.1929.52.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 16:45 +0900, MyungJoo Ham wrote:
> This patch enables IRQ handling for MAX8997/8966 chips.

Just trivial comments.

> +++ b/drivers/mfd/max8997-irq.c
> +static u8 max8997_mask_reg[] = {

static const?

[]

> +static struct max8997_irq_data max8997_irqs[] = {

here too?

> +	[MAX8997_PMICIRQ_PWRONR] = {
> +		.group	= PMIC_INT1,
> +		.mask	= 1 << 0,
> +	},

I think the declaration style is a little hard to
read and verify.  Maybe use a macro something like:

#define DECLARE_IRQ(val, _group, _mask)			\
	[ val ] = { .group = _group, .mask = _mask }

> +	[MAX8997_PMICIRQ_PWRONF] = {
> +		.group	= PMIC_INT1,
> +		.mask	= 1 << 1,
> +	},

So this becomes

	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONR, PMIC_INT1, 1 << 0),
	DECLARE_IRQ(MAX8997_PMICIRQ_PWRONF, PMIC_INT1, 1 << 1),
	etc...

[]

> +static struct irq_chip max8997_irq_chip = {

static const?

> +static irqreturn_t max8997_irq_thread(int irq, void *data)
> +{
> +	struct max8997_dev *max8997 = data;
> +	u8 irq_reg[MAX8997_IRQ_GROUP_NR];
[]
> +	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++)
> +		irq_reg[i] = 0;

Maybe use a memset or change the declaration to
	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};


