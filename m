Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0GPRZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:25:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22739 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0GPRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:25:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6045"; a="47555692"
From: "Ai Li" <aili@codeaurora.org>
To: "'Arjan van de Ven'" <arjan@linux.intel.com>
Cc: <akpm@linux-foundation.org>, <dwalker@codeaurora.org>, <mingo@elte.hu>,
        <shemminger@vyatta.com>, <czoccolo@gmail.com>, <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
References: <1279225825-31069-1-git-send-email-aili@codeaurora.org> <4C3FDAF1.7030107@linux.intel.com>
In-Reply-To: <4C3FDAF1.7030107@linux.intel.com>
Subject: RE: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic states
Date: Fri, 16 Jul 2010 11:25:27 -0600
Message-ID: <000001cb250b$e2813e60$a783bb20$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcsknGsRrU6SRWRhR1a91A4rxQIfRQAaQ0sg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (dev->prepare)
> > +		dev->prepare(dev, data->predicted_us);
> >
> 
> I don't like the idea of passing predicted_us here.
> the states and their updates should be independent of how long we
> think we'll be idle;

The power_usage value, total or average, would depend on how long the
predicted idle period is.  On our SoCs, a cpuidle state has three
stages: entry stage, low power stage, and exit stage.  Entry and exit
stages consume more power than the low power stage but have fixed
durations, irrespective how long the idle period is.  As the
predicted idle period changes, the entry and exit duration stay the
same but the low power duration changes, resulting in different total
or average power for the idle period.


> Also I would like the cpuidle code, not the governor, to call this
> prepare function.
> The need to call ->prepare is governor independent....

I agree that it would be cleaner to call ->prepare from the cpuidle
code.  But if we need values calculated in the governor's select
function, I'm not sure what is the best way to do that from cpuidle
code.

 
> + if (dev->compare_power) {
> 
> I'm not a big fan of this as a flag; either we always do this,
> which I
> can understand, or we sort things, which is also fine with me.
> Doing this condition like this.... not a fan.

One of the concerns I have is backwards compatibility.  As far as I
know, none of the current cpuidle drivers use the power_usage field.
If we always do compare_power, those drivers would break until
someone with technical device knowledge update the drivers to specify
power...  I could derive fake power_usage numbers by default, using
the cstate index position.  That seems kind of hacky but it would
remove the need for the compare_power flag and retain the current
behavior when cpuidle drivers do not provide their own power numbers.

~Ai

Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

