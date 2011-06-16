Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1FPAy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:54:59 -0400
Received: from mail.geekisp.com ([216.168.135.169]:34711 "EHLO
	starfish.geekisp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753209Ab1FPAy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:54:58 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jun 2011 20:54:58 EDT
Message-ID: <4DF952CC.4010301@balister.org>
Date: Wed, 15 Jun 2011 17:48:12 -0700
From: Philip Balister <philip@balister.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        "'Daniel Walker'" <dwalker@codeaurora.org>, linux-mm@kvack.org,
        "'Mel Gorman'" <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory	Allocator
 added
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>	<201106142030.07549.arnd@arndb.de>	<000501cc2b2b$789a54b0$69cefe10$%szyprowski@samsung.com> <201106150937.18524.arnd@arndb.de>
In-Reply-To: <201106150937.18524.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 12:37 AM, Arnd Bergmann wrote:
> On Wednesday 15 June 2011 09:11:39 Marek Szyprowski wrote:
>> I see your concerns, but I really wonder how to determine the properties
>> of the global/default cma pool. You definitely don't want to give all
>> available memory o CMA, because it will have negative impact on kernel
>> operation (kernel really needs to allocate unmovable pages from time to
>> time).
>
> Exactly. This is a hard problem, so I would prefer to see a solution for
> coming up with reasonable defaults.

Is this a situation where passing the information from device tree might 
help? I know this does not help short term, but I am trying to 
understand the sorts of problems device tree can help solve.

Philip

>
>> The only solution I see now is to provide Kconfig entry to determine
>> the size of the global CMA pool, but this still have some issues,
>> especially for multi-board kernels (each board probably will have
>> different amount of RAM and different memory-consuming devices
>> available). It looks that each board startup code still might need to
>> tweak the size of CMA pool. I can add a kernel command line option for
>> it, but such solution also will not solve all the cases (afair there
>> was a discussion about kernel command line parameters for memory
>> configuration and the conclusion was that it should be avoided).
>
> The command line option can be a last resort if the heuristics fail,
> but it's not much better than a fixed Kconfig setting.
>
> How about a Kconfig option that defines the percentage of memory
> to set aside for contiguous allocations?
>
> 	Arnd
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>
