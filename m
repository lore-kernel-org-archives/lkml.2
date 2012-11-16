Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2KPJod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:44:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15112 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2KPJob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:44:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 16 Nov 2012 01:44:29 -0800
Message-ID: <50A60AF6.9080509@nvidia.com>
Date: Fri, 16 Nov 2012 18:44:22 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com> <1353047903-14363-2-git-send-email-acourbot@nvidia.com> <20121116072642.GA22291@lizard>
In-Reply-To: <20121116072642.GA22291@lizard>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 04:26 PM, Anton Vorontsov wrote:
>> +#include "power_seq_delay.c"
>> +#include "power_seq_regulator.c"
>> +#include "power_seq_pwm.c"
>> +#include "power_seq_gpio.c"
>
> This is odd, although I remember you already explained why you have to
> include the .c files, instead of linking them separately. But I forgot the
> reason. :) I think this deserves a comment in the code.

This is because of the table right after these includes:

static const struct power_seq_res_ops power_seq_ops[POWER_SEQ_NUM_TYPES] = {
	[POWER_SEQ_DELAY] = POWER_SEQ_DELAY_TYPE,
	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
};

The POWER_SEQ_*_TYPE macros are defined in the C files. It's the 
simplest way to initialize this table, and the code inside these C files 
is short and simple enough that I thought I would be forgiven. :)

At first everything was in power_seq.c and it was fine, then I thought 
it would be better to move resource support code into their own filesm 
and now everybody is asking. :P

But yeah, maybe it would be even better to not stop halfway and use 
dynamic linking.

Comment added for the time being. ;)

>> +static int of_power_seq_parse_step(struct device *dev,
>> +				   struct device_node *node,
>> +				   struct power_seq *seq,
>> +				   unsigned int step_nbr,
>> +				   struct list_head *resources)
>> +{
>> +	struct power_seq_step *step = &seq->steps[step_nbr];
>> +	struct power_seq_resource res, *res2;
>> +	const char *type;
>> +	int i, err;
>
> nit: one variable declaration per line.

Fair enough - but is that a convention? checkpatch.pl was happy with these.

Thanks,
Alex.


