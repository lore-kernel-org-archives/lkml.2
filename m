Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2AYL0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:26:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49791 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333Ab2AYL0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:26:05 -0500
Date: Wed, 25 Jan 2012 11:26:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
Message-ID: <20120125112602.GB2991@opensource.wolfsonmicro.com>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1FD1A5.1060305@samsung.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:55:49AM +0100, Karol Lewandowski wrote:
> On 12.01.2012 08:35, Thomas Abraham wrote:
> >Add device tree based discovery support for max8997.
> 
> >+	pdata->regulators = rdata;
> >+	for_each_child_of_node(regulators_np, reg_np) {
> >+		for (i = 0; i<  ARRAY_SIZE(regulators); i++)
> >+			if (!of_node_cmp(reg_np->name, regulators[i].name))
> >+				break;
> >+		rdata->id = i;
> >+		rdata->initdata = of_get_regulator_init_data(
> >+						iodev->dev, reg_np);

> One more thing - of_get_regulator_init_data() will set apply_uV to 1
> so we need to reset it for BUCK6, which doesn't provide
> set_voltage() ops, like:

> 	if (rdata->initdata && regulators[i].id == MAX8997_BUCK6)
> 		rdata->initdata->constraints.apply_uV = 0;

So, over in the other thready you were referring to mailing list posts
you made in the past few moments as examples of past issues.  Please at
least mention that there hasn't been any actual discussion when doing
this...

I don't see a problem here, if the device can't set the voltage then
setting constraints to allow the voltage to be changed is silly and the
user just shouldn't do that.
