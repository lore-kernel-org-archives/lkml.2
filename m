Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2GDHGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:06:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5519 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GDHGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:06:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jul 2012 00:06:27 -0700
Message-ID: <4FF3EA70.307@nvidia.com>
Date: Wed, 4 Jul 2012 12:32:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: fixed: dt: support for input supply
References: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com> <1341223645-7817-2-git-send-email-ldewangan@nvidia.com> <20120703191704.GE29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703191704.GE29030@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2012 12:47 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 02, 2012 at 03:37:25PM +0530, Laxman Dewangan wrote:
>
>> +	if (vin_supply)
>> +		drvdata->desc.supply_name = "vin";
>> +
> This isn't great both in terms of it being conditional and the fact that
> it's only usable on DT systems as there's no non-DT way to do this.  In
> general unless we're working around some device tree issue (which should
> be *very* rare) we shouldn't be adding any DT only stuff to generic
> code, we need to be able to run Linux on non-DT systems.
>

In non-DT, the input supply is passed with the regulator_init_data 
through the fixed voltage config and it is filled in board files.
In one of discussion on input supply in my old patch, I understand that  
we should not provide the supply_regulator through the init_data as it 
is legacy and should provide with desc->supply_name.

so matching with this I have this change and put th supply regulator in 
desc->supply_name.

If we want to keep the same as DT and non-DT and not the extra care for 
this new policy then we can put the parsing code in 
of_get_fixed_voltage_config() and just fill the 
config->init_data->supply_regulator in this function.
The property checking for vin-supply can be done in this function only 
and set the config->init_data->supply_regulator = "vin" accordingly.

In this way there is no code for DT/Non-DT case.

Let me know your opinion.
