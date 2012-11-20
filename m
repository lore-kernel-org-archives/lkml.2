Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2KTNU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:20:26 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9483 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2KTNUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:20:25 -0500
Message-id: <50AB8394.1010207@samsung.com>
Date: Tue, 20 Nov 2012 14:20:20 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v3] regulator: treat regulators with constant volatage as
 fixed
References: <20121113094255.GW18224@opensource.wolfsonmicro.com>
 <1352800177-16139-1-git-send-email-m.szyprowski@samsung.com>
 <20121114020124.GH4415@opensource.wolfsonmicro.com>
In-reply-to: <20121114020124.GH4415@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/14/2012 3:01 AM, Mark Brown wrote:
> On Tue, Nov 13, 2012 at 10:49:37AM +0100, Marek Szyprowski wrote:
>
> > +	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
> > +		if (rdev->desc->n_voltages)
> > +			return rdev->desc->n_voltages;
> > +		else
> > +			return -EINVAL;
> > +	} else {
> > +		return 1;
> > +	}
>
> Hrm, now I can read the logic I'm not convinced this is a good idea.
> This will report that we have an available voltage for devices which
> don't know their voltage (things like battery supplies often do this as
> the voltage is unregulated) and it will mean that we are doing something
> different for the case where there's only one voltage (reporting the
> restricted count instead of the physically supported count).
>
> I think we want a regulator_can_change_voltage() or possibly a count
> function (though I can't see any use cases except this) which answers
> the question directly instead of layering on top of this function.

Right, regulator_can_change_voltage() sounds much better than my hacky
approach. The first client would be probably sdhci/mmc driver, as
'can_change_voltage' check sounds much more appropriate than counting
available voltage values.

I will prepare patches soon.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


