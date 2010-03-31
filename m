Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0CaWRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:17:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:52362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab0CaWRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:17:38 -0400
Message-ID: <4BB3C9B0.4000205@kernel.org>
Date: Wed, 31 Mar 2010 15:16:16 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <4BB3C739.2020106@kernel.org> <20100331221341.GA20441@elte.hu>
In-Reply-To: <20100331221341.GA20441@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 03:13 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> --- linux-2.6.orig/arch/x86/mm/init_32.c
>> +++ linux-2.6/arch/x86/mm/init_32.c
>> @@ -875,7 +875,12 @@ void __init mem_init(void)
>>  	BUG_ON(!mem_map);
>>  #endif
>>  	/* this will put all low memory onto the freelists */
>> +#if defined(CONFIG_NO_BOOTMEM) && defined(MAX_NUMNODES)
>> +	/* In case some 32bit systems don't have RAM installed on node0 */
>> +        totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
> 
> (Note: tab whitespace damage)
> 
>> +#else
>>  	totalram_pages += free_all_bootmem();
> 
> So we get into this branch if CONFIG_NO_BOOTMEM is enabled but MAX_NUMNODES is 
> not defined? Doesnt look right.

yes. 

free_all_bootmem() will call
free_all_memory_core_early(NODE_DATA(0)->node_id);

Thanks

Yinghai Lu
