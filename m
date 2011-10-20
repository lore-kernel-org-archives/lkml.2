Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1JTPVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:21:45 -0400
Received: from mail.fuel7.com ([74.222.0.51]:37623 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab1JTPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:21:44 -0400
Message-ID: <4EA03C86.7020900@fuel7.com>
Date: Thu, 20 Oct 2011 10:21:42 -0500
From: Kyle Manna <kyle.manna@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 5/6] mfd: TPS65910: Fix tps65910_set_voltage
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com> <1318962388-26151-6-git-send-email-kyle.manna@fuel7.com> <20111019133258.GG18713@sirena.org.uk>
In-Reply-To: <20111019133258.GG18713@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I've reviewed the patch and the core regulator framework after reading 
your comments.  This patch worked around a subtle bug that I didn't 
notice and is hence not needed.  The root cause was fixed and the 
voltage selectors work as desired.

Will update the patch series and resend.

- Kyle

On 10/19/2011 08:32 AM, Mark Brown wrote:
> On Tue, Oct 18, 2011 at 01:26:27PM -0500, Kyle Manna wrote:
>
> *Always* CC maintainers on patches.
>
>> Previously tps65910_set_voltage() only selected from a fixed number of
>> voltages.  Rename that function to tps65910_set_voltage_sel(). Do the
>> same for tps65911_set_voltage().
> What is the issue being fixed here?  This looks like a stylistic change
> rateher than a bug fix.
>
>> Also add a tps65910_set_voltage that works with the regulator framework
>> and applies the correct voltage with apply_uv is set in the regulator's
>> constraints.
> So this is adding support for a new chip?  Whatever the answer it's
> clearly a distinct change from the above and should therefore be a
> separate patch.
>
>> +	/* Pick the nearest selector */
>> +	for (i = 0; i<  tps65910_regs[id].table_len; i++) {
>> +		new_uV = tps65910_regs[id].table[i] * 1000;
>> +
>> +		if (new_uV>= min_uV&&  new_uV<= max_uV&&
>> +		   (abs(new_uV - midpoint)<  abs(selected_uV - midpoint))) {
>> +			*selector = i;
>> +			selected_uV = tps65910_regs[id].table[i] * 1000;
>> +		}
>> +	}
> This looks wrong, the expected behaviour for the regulator API is that
> the driver will pick the minimum voltage within the range.  Why is this
> being done?

