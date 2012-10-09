Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2JIXxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:53:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36307 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JIXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:53:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5074B8B5.3010307@jp.fujitsu.com>
Date: Wed, 10 Oct 2012 08:52:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the origin tree
References: <20121010102150.81c192c6fdf60689dc823b20@canb.auug.org.au> <20121009164514.b7a7e227.akpm@linux-foundation.org>
In-Reply-To: <20121009164514.b7a7e227.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

2012/10/10 8:45, Andrew Morton wrote:
> On Wed, 10 Oct 2012 10:21:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi Linus,
>>
>> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig) failed
>> like this:
>>
>> arch/powerpc/platforms/pseries/hotplug-memory.c: In function 'pseries_remove_memblock':
>> arch/powerpc/platforms/pseries/hotplug-memory.c:103:17: error: unused variable 'pfn' [-Werror=unused-variable]
>>
>> Caused by commit d760afd4d257 ("memory-hotplug: suppress "Trying to free
>> nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning").
>>
>> I can't see what the point of the "pfn" variable is
>
> This:
>
> --- a/arch/powerpc/platforms/pseries/hotplug-memory.c~a
> +++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
> @@ -101,7 +101,7 @@ static int pseries_remove_memblock(unsig
>   	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
>   	for (i = 0; i < sections_to_remove; i++) {
>   		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
> -		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
> +		ret = __remove_pages(zone, pfn, PAGES_PER_SECTION);
>   		if (ret)
>   			return ret;
>   	}

I believe the error to be fixed with this patch.
Could you try it?

Thanks,
Yasuaki Ishimatsu

>
>> and this patch never
>> appeared in linux-next before being merged.  :-(
>
> It was first sighted October 3.
>
>> I have reverted that commit for today.
>>
>> If this patch truly was authored yesterday (according the Author Date in
>> git), why was it merged yesterday while still under discussion?  And the
>> latest update to it still has this build problem ... did anyone even try
>> to build this for powerpc (since that architecture was obviously
>> affected)?
>
> Apparently not - the ppc bit was a best-effort fixup for a patch which
> addresses an x86 problem.
>


