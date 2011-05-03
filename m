Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1ECQbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:31:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62707 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1ECQbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:31:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6334"; a="89257255"
Message-ID: <4DC02DD4.9000505@codeaurora.org>
Date: Tue, 03 May 2011 09:31:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
CC: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, lrg@ti.com, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Subject: Re: [PATCH 2/5] regulator: tps65911: Add new chip version
References: <91D0C3C1-66A6-4642-8F78-EFE99236D1A7@slimlogic.co.uk>
In-Reply-To: <91D0C3C1-66A6-4642-8F78-EFE99236D1A7@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 09:18 AM, Jorge Eduardo Candelaria wrote:
> @@ -419,17 +541,21 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
>  		mult=1;
>  
>  	if (sr) {
> -		/* Valid range is 3-75 so normalise */
> -		if (srvsel < 3) srvsel = 3;
> -		if (srvsel > 75) srvsel = 75;
> +		/* normalise to valid range */
> +		if (srvsel < 3)
> +			srvsel = 3;
> +		if (srvsel > vselmax)
> +			srvsel = vselmax;
>  		srvsel -= 3;
>  
>  		voltage = (srvsel * VDD1_2_OFFSET + VDD1_2_MIN_VOLT) * 100;
>  	} else {
>  
> -		/* Valid range is 3-75 so normalise */
> -		if (opvsel < 3) opvsel = 3;
> -		if (opvsel > 75) opvsel = 75;
> +		/* normalise to valid range*/
> +		if (opvsel < 3)
> +			opvsel = 3;
> +		if (opvsel > vselmax)
> +			opvsel = vselmax;

Can we use clamp() instead?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

