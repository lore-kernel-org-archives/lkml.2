Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1LBQcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:32:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:60815 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab1LBQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:32:21 -0500
Message-ID: <4ED8FD76.3000802@windriver.com>
Date: Fri, 2 Dec 2011 11:31:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com> <201112011419.46751.arnd@arndb.de> <CAP=VYLrp1zqyOzU-xzatF3jE3wL6wBjEDMR=sEXimP2ZvkQ0Lg@mail.gmail.com> <alpine.LFD.2.02.1112020005270.2357@xanadu.home> <alpine.LFD.2.02.1112020024370.2357@xanadu.home> <20111202092124.GR26618@pengutronix.de>
In-Reply-To: <20111202092124.GR26618@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-02 04:21 AM, Uwe Kleine-König wrote:
> Hello Nicolas,
> 
> On Fri, Dec 02, 2011 at 12:33:26AM -0500, Nicolas Pitre wrote:

[...]

>> And it seems that at91x40 is the only defconfig with MMU=n, so the only 
>> option is really to provide a default CONFIG_PHYS_OFFSET.  So what about 
>> this:
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index e084b7e981..a24672924f 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -222,6 +222,7 @@ config NEED_MACH_MEMORY_H
>>  config PHYS_OFFSET
>>  	hex "Physical address of main memory"
>>  	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
>> +	default DRAM_BASE if !MMU
>>  	help
>>  	  Please provide the physical address corresponding to the
>>  	  location of main memory in your system.
>>
>> Eventually the DRAM_BASE config option could simply be replaced by 
>> PHYS_OFFSET directly, but that's a larger change.
> I'm working on a MMU-less machine, too and had that change already in my
> working copy. I was about to commit and it send out later today.
> 
> So: Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Looks fine to me as well; I had no particular attachment to the
original patch, and you guys have a much better understanding of
the specifics of the system.

Thanks,
Paul.

> 
> Best regards
> Uwe
> 
