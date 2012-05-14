Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2ENCd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:33:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58955 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2ENCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:33:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4FB06F09.5060105@jp.fujitsu.com>
Date: Mon, 14 May 2012 11:33:45 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: add kernelcore_max_addr boot option
References: <4FACA79C.9070103@cn.fujitsu.com> <20120511133939.25b5a738.akpm@linux-foundation.org>
In-Reply-To: <20120511133939.25b5a738.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

2012/05/12 5:39, Andrew Morton wrote:
> On Fri, 11 May 2012 13:46:04 +0800
> Lai Jiangshan<laijs@cn.fujitsu.com>  wrote:
>
>> Current ZONE_MOVABLE (kernelcore=) setting policy with boot option doesn't meet
>> our requirement. We need something like kernelcore_max_addr= boot option
>> to limit the kernelcore upper address.
>
> Why do you need this?  Please fully describe the requirement/use case.

We want to create removable node for removing a system board
which equip CPU and memory at runtime. To do this, all memory
of a node on system board must be allocated as ZONE_MOVABLE.
But current linux cannot do it.
So we create removable node by limiting the memory address of
the kernelcore by the boot option.

Thanks,
Yasuaki Ishimatsu

>> The memory with higher address will be migratable(movable) and they
>> are easier to be offline(always ready to be offline when the system don't require
>> so much memory).
>>
>> All kernelcore_max_addr=, kernelcore= and movablecore= can be safely specified
>> at the same time(or any 2 of them).
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>
>
>


