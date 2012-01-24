Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2AXMiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:38:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17804 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2AXMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:38:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 04:38:02 -0800
Message-ID: <4F1EA608.3020204@nvidia.com>
Date: Tue, 24 Jan 2012 18:07:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: tps65910: Sleep control through external
 inputs
References: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com> <20120124115855.GC14888@opensource.wolfsonmicro.com> <4F1EA1E8.90104@nvidia.com> <20120124122411.GB31839@opensource.wolfsonmicro.com>
In-Reply-To: <20120124122411.GB31839@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 January 2012 05:54 PM, Mark Brown wrote:
> On Tue, Jan 24, 2012 at 05:49:52PM +0530, Laxman Dewangan wrote:
> The external controls for different rails are managed by power
>> manament driver of soc in kernel to toggel them. The bootloader make
>> sure that all external control signals are active just before
>> jumping into kernel so that there is no issue during regulator init.
>> When system reboots in kernel by kernel command, the configuration
>> of the pmu still maintain as what it was in kernel before reboot and
>> issue  system reboots. There is possibility that the default (POR)
>> of these control signals are not active on soc reset or initial
>> stage of the bootloader and hence it can turn off the rails which
>> can avoid system booting.
>> So kernel need to remove all external controls before reboot system.
> The code needs to explain this stuff so readers will know.
>
Will add this information in code.
>
>> Hmm.., I thought that  suspend mode apis manages the low/full-on
>> power mode when the controls are not through external inputs. There
>> is different register for configuring the power mode by i2c- write.
>> This macro help in configuration of mode when enabled with external
>> controls which configures in different sets of register.
> No, usually it's used for configuring suspend mode when the PMIC knows
> about system suspend.
>
Ok, will move this configuration with the  suspend mode and program the 
correct register based on external signals.

> I used this member in the probe as for configuring the rails..
>> +        err = tps65910_set_ext_sleep_config(pmic, i,
>> +                pmic_plat_data->regulator_ext_sleep_control[i]);
> Right, but I can't see any code which manages the signals at runtime.
> You tell the device to use the signals but the signals aren't (as far as
> I can see) controlled by software.
I dont think we need to supply information that how EN1/EN2/EN3 toggles 
from external word?
This should be done on the consumer driver  for these rails to toggle 
the signals based on requirements.

E.g. If cpu power is in VDDCTRL rail and if DVFS mechanism of SOC wants 
that cpu rails to be ON, it will make the control signal active and if 
it wants to disable the rail then it will deactivate it.
The toggling of the control lines depends on how the power management 
controller is designed for a given SOC and how it manages.




> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

