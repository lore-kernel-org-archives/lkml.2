Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1BYUXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:23:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64141 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab1BYUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:23:19 -0500
Message-ID: <4D680F77.5060107@kernel.org>
Date: Fri, 25 Feb 2011 12:22:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86,mm,64bit: Round up memory boundary for init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org> <4D657359.5060901@kernel.org> <20110223210326.GB27738@atj.dyndns.org> <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com> <20110224091557.GD7840@htj.dyndns.org> <4D674A33.8000809@kernel.org> <20110225100336.GA26608@elte.hu>
In-Reply-To: <20110225100336.GA26608@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D680F9E.0145,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 02:03 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>>  init_memory_mapping_active_regions(unsigned long start, unsigned long end)
>>  {
>>  	struct mapping_work_data data;
>> +	int use_gbpages;
>> +
>> +	/* see init_memory_mapping() for the setting */
>> +#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>> +	use_gbpages = 0;
>> +#else
>> +	use_gbpages = direct_gbpages;
>> +#endif
> 
> Sigh. You should *never* ever even think about writing such code. It only results in 
> crap, and in crap duplicated elsewhere as well:
> 
> if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
>         /*
>          * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
>          * This will simplify cpa(), which otherwise needs to support splitting
>          * large pages into small in interrupt context, etc.
>          */
>         use_pse = use_gbpages = 0;
> #else
>         use_pse = cpu_has_pse;
>         use_gbpages = direct_gbpages;
> #endif

sorry, actually i copied from there.

or i could add max_map_unit_size variable?

Thanks

Yinghai


