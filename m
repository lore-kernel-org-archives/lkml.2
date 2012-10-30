Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375Ab2J3SZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:25:04 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:48392 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760198Ab2J3SY5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:24:57 -0400
Subject: Re: [PATCH] omap: Export various omap_hwmod related functions
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121030182215.GN11908@atomide.com>
Date: Tue, 30 Oct 2012 20:24:52 +0200
Cc: Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E80C6CE6-189C-4B77-BAC8-A9B9FCA935DB@antoniou-consulting.com>
References: <1351699014-4259-1-git-send-email-panto@antoniou-consulting.com> <20121030182215.GN11908@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

The patches that use them are going to be posted in about 30mins.
They will make this clear.

Regards

-- Pantelis

On Oct 30, 2012, at 8:22 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121030 11:05]:
>> omap_hwmod_lookup / omap_device_build / omap_device_build_ss;
>> these functions can be used just fine by modules, there's no need not
>> to have them exported.
> 
> Just curious, where do you plan to use these?
> 
> These will be private to arch/arm/mach-omap2 and won't be available
> to drivers with the patches we have queued up in
> omap-for-v3.8/cleanup-headers branch.
> 
> Regards,
> 
> Tony
> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> arch/arm/mach-omap2/omap_hwmod.c | 2 ++
>> arch/arm/plat-omap/omap_device.c | 6 ++++--
>> 2 files changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
>> index b969ab1..5b8b6ec 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod.c
>> @@ -138,6 +138,7 @@
>> #include <linux/spinlock.h>
>> #include <linux/slab.h>
>> #include <linux/bootmem.h>
>> +#include <linux/export.h>
>> 
>> #include <plat/clock.h>
>> #include <plat/omap_hwmod.h>
>> @@ -3041,6 +3042,7 @@ struct omap_hwmod *omap_hwmod_lookup(const char *name)
>> 
>> 	return oh;
>> }
>> +EXPORT_SYMBOL(omap_hwmod_lookup);
>> 
>> /**
>>  * omap_hwmod_for_each - call function for each registered omap_hwmod
>> diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
>> index 7a7d1f2..a15b715 100644
>> --- a/arch/arm/plat-omap/omap_device.c
>> +++ b/arch/arm/plat-omap/omap_device.c
>> @@ -663,7 +663,7 @@ void omap_device_delete(struct omap_device *od)
>>  * information.  Returns ERR_PTR(-EINVAL) if @oh is NULL; otherwise,
>>  * passes along the return value of omap_device_build_ss().
>>  */
>> -struct platform_device __init *omap_device_build(const char *pdev_name, int pdev_id,
>> +struct platform_device *omap_device_build(const char *pdev_name, int pdev_id,
>> 				      struct omap_hwmod *oh, void *pdata,
>> 				      int pdata_len,
>> 				      struct omap_device_pm_latency *pm_lats,
>> @@ -678,6 +678,7 @@ struct platform_device __init *omap_device_build(const char *pdev_name, int pdev
>> 				    pdata_len, pm_lats, pm_lats_cnt,
>> 				    is_early_device);
>> }
>> +EXPORT_SYMBOL(omap_device_build);
>> 
>> /**
>>  * omap_device_build_ss - build and register an omap_device with multiple hwmods
>> @@ -696,7 +697,7 @@ struct platform_device __init *omap_device_build(const char *pdev_name, int pdev
>>  * platform_device record.  Returns an ERR_PTR() on error, or passes
>>  * along the return value of omap_device_register().
>>  */
>> -struct platform_device __init *omap_device_build_ss(const char *pdev_name, int pdev_id,
>> +struct platform_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
>> 					 struct omap_hwmod **ohs, int oh_cnt,
>> 					 void *pdata, int pdata_len,
>> 					 struct omap_device_pm_latency *pm_lats,
>> @@ -751,6 +752,7 @@ odbs_exit:
>> 
>> 	return ERR_PTR(ret);
>> }
>> +EXPORT_SYMBOL(omap_device_build_ss);
>> 
>> /**
>>  * omap_early_device_register - register an omap_device as an early platform
>> -- 
>> 1.7.12
>> 

