Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0KRAfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 19:35:16 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45769 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0KRAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 19:35:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6170"; a="63307777"
Subject: Re: [PATCH 1/2] drivers: regulator: core: use pr_fmt
From: Daniel Walker <dwalker@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, bleong@codeaurora.org
In-Reply-To: <1290040194.28741.324.camel@Joe-Laptop>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
	 <1290040194.28741.324.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 16:35:08 -0800
Message-ID: <1290040508.16344.532.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:29 -0800, Joe Perches wrote:
> On Wed, 2010-11-17 at 15:30 -0800, Daniel Walker wrote:
> > This adds a pr_fmt line which uses the __func__ macro. I also
> > convert the current pr_ lines to remove their __func__ usage.
> []
> > diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> > @@ -765,8 +767,8 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
> >  
> >  		/* else require explicit machine-level constraints */
> >  		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> > -			pr_err("%s: %s '%s' voltage constraints\n",
> > -				       __func__, "invalid", name);
> > +			pr_err("%s '%s' voltage constraints\n", "invalid",
> > +				name);
> 
> Using a separate pointer for invalid and unsupportable
> doesn't save much text space and is very hard to grep.
> 
> I think it's more intelligible as:
> 
> 			pr_err("%s: Invalid voltage constraints\n", name);

I noticed that also, but I didn't feel like changing it when I did this.


there is another one here,

                        printk(KERN_WARNING "%s: could not add regulator_dev"
                                " load sysfs\n", __func__);

I'm not sure what this one was suppose to say.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

