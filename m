Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2H3JLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:11:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:19801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2H3JLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,338,1344236400"; 
   d="scan'208";a="187063362"
Message-ID: <503F2E2D.9000803@intel.com>
Date: Thu, 30 Aug 2012 17:11:09 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, andi@firstfloor.org,
        mingo@elte.hu
Subject: Re: [PATCH] perf/x86: export Sandy Bridge uncore clockticks event
 in sysfs
References: <20120829130122.GA32336@quad>
In-Reply-To: <20120829130122.GA32336@quad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 09:01 PM, Stephane Eranian wrote:
> 
> This patch exports the clockticks event and its encoding to user level.
> The clockticks event was exported for Nehalem/Westmere but not for Sandy
> Bridge (client). Given that it uses a special encoding, it needs to be
> exported to user tools, so users can do:
> 
>   # perf stat -a -C 0 -e uncore_cbox_0/clockticks/ sleep 1
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

The Sandy Bridge uncore only contains a few events that are similar to offcore event.
That's why I didn't add any generic event for Sandy Bridge uncore. But thanks anyway.

Acked-by: Yan, Zheng <zheng.z.yan@intel.com>

> ---
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 0a55710..38e4894 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -661,6 +661,11 @@ static void snb_uncore_msr_init_box(struct intel_uncore_box *box)
>  	}
>  }
>  
> +static struct uncore_event_desc snb_uncore_events[] = {
> +	INTEL_UNCORE_EVENT_DESC(clockticks, "event=0xff,umask=0x00"),
> +	{ /* end: all zeroes */ },
> +};
> +
>  static struct attribute *snb_uncore_formats_attr[] = {
>  	&format_attr_event.attr,
>  	&format_attr_umask.attr,
> @@ -704,6 +709,7 @@ static struct intel_uncore_type snb_uncore_cbox = {
>  	.constraints	= snb_uncore_cbox_constraints,
>  	.ops		= &snb_uncore_msr_ops,
>  	.format_group	= &snb_uncore_format_group,
> +	.event_descs	= snb_uncore_events,
>  };
>  
>  static struct intel_uncore_type *snb_msr_uncores[] = {
> 

