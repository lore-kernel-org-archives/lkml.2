Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074Ab1EDHbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:31:34 -0400
Received: from christianhoffmann.info ([88.175.101.52]:48596 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1EDHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:31:33 -0400
Message-ID: <4DC100D0.1030302@christianhoffmann.info>
Date: Wed, 04 May 2011 09:31:28 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>	 <1304372955.3226.15.camel@work-vm>	 <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
In-Reply-To: <1304470839.3037.12.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 03:00 AM, john stultz wrote:
> On Tue, 2011-05-03 at 00:27 +0200, Christian Hoffmann wrote:
>>>
>>> Can you reproduce the hang booting with "clocksource=hpet" and
>>> "clocksource=acpi_pm" ?
>>
>> Both hang also.
>
> Sorry, one more clarifying point here:
>
> When you used either clocksource=hpet/clocksource=acpi_pm did the
> behavior of the system seem different after booting? In other words:
> does running time waiting a few seconds and then running time again show
> the expected passage of time?  Were any following hangs seen, or was it
> only the first one at boot?

Hi,

with hpet no problems seen. No further hangs either.

In fact, switching to acpi_pm doesn't seem to work:

$ dmesg | grep clock

[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+ 
root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
[    0.000000] Kernel command line: 
BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+ root=/dev/mapper/vg-root ro 
quiet splash vt.handoff=7 clocksource=acpi_pm
[    0.000000] hpet clockevent registered
[    1.413835] Switching to clocksource hpet
[    1.420762] Override clocksource acpi_pm is not HRT compatible. 
Cannot switch while in HRT/NOHZ mode
[  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
[  147.940147] Switching to clocksource tsc


Regards,
Chris
