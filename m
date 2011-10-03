Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1JCJdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:33:41 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:42460 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab1JCJdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:33:36 -0400
Message-ID: <4E89816A.5050704@ti.com>
Date: Mon, 03 Oct 2011 15:03:30 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/30] ARM: omap: select CPU_FREQ_TABLE where needed
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-29-git-send-email-arnd@arndb.de> <4E894A95.5030107@ti.com> <5173921.eT2vCfT35d@wuerfel>
In-Reply-To: <5173921.eT2vCfT35d@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 02:45 PM, Arnd Bergmann wrote:
> On Monday 03 October 2011 11:09:33 Santosh Shilimkar wrote:
>>> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
>>> index bb8f4a6..f7ef9f4 100644
>>> --- a/arch/arm/plat-omap/Kconfig
>>> +++ b/arch/arm/plat-omap/Kconfig
>>> @@ -217,6 +217,11 @@ config OMAP_PM_NOOP
>>>  
>>>  endchoice
>>>  
>>> +config OMAP_CPU_FREQ
>>> +     def_bool "y"
>>> +     depends on CPU_FREQ
>>> +     select CPU_FREQ_TABLE
>>> +
>>>  endmenu
>> With CPUFREQ series from Kevin [1], I don't think we need this any-more.
> 
> I guess if it's needed, it should at least be moved to the new cpufreq
> location.
> 
Probably you are right. CPU_FREQ_TABLE is selected today if
CPU_FREQ_STAT or CPU_FREQ_GOV_ONDEMAND is selected. Without these two
enabled, in won't be selected.

>> More so, I didn't find OMAP_CPU_FREQ is being used anywhere on mainline.
> 
> Yes, OMAP_CPU_FREQ is a symbol that is intentionally unused, with the
> only purpose of selecting CPU_FREQ_TABLE if any omap platform together
> with CPU_FREQ is enabled.
>
I see. This wasn't clear to me.

> Let's drop this patch for now, if it is still needed as I think, I can
> do a patch during the 3.2 cycle for the right location.
> 
Ok.

Regards
Santosh
