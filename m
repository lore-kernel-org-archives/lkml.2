Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1ADI60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:58:26 -0500
Received: from [120.204.251.227] ([120.204.251.227]:18498 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298Ab1ADI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:58:25 -0500
Message-ID: <4D22E0CF.8000307@leadcoretech.com>
Date: Tue, 04 Jan 2011 16:56:47 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101230 Lightning/1.0b2 Lanikai/3.1.7
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <figo1802@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3]mm/oom-kill: direct hardware access processes should
 get bonus
References: <1288662213.10103.2.camel@localhost.localdomain>	<1289305468.10699.2.camel@localhost.localdomain>	<1289402093.10699.25.camel@localhost.localdomain>	<1289402666.10699.28.camel@localhost.localdomain>	<4D22D190.1080706@leadcoretech.com> <20110104172833.1ff20b41.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110104172833.1ff20b41.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2011 08:58:24.0098 (UTC) FILETIME=[8B302C20:01CBABED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 04:28 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 04 Jan 2011 15:51:44 +0800
> "Figo.zhang"<zhangtianfei@leadcoretech.com>  wrote:
>
>>
>> i had send the patch to protect the hardware access processes for
>> oom-killer before, but rientjes have not agree with me.
>>
>> but today i catch log from my desktop. oom-killer have kill my "minicom"
>> and "Xorg". so i think it should add protection about it.
>>
>
> Off topic.
>
> In this log, I found
>
>>> Jan  4 15:22:55 figo-desktop kernel: Free swap  = -1636kB
>>> Jan  4 15:22:55 figo-desktop kernel: Total swap = 0kB
>>> Jan  4 15:22:55 figo-desktop kernel: 515070 pages RAM
>
> ... This means total_swap_pages = 0 while pages are read-in at swapoff.
>
> Let's see 'points' for oom
> ==
> points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS)) * 1000 /
>                          totalpages;
> ==
>
> Here, totalpages = total_ram + total_swap but totalswap is 0 here.
>
> So, points can be>  1000, easily.
> (This seems not to be related to the Xorg's death itself)

total_swap is 0, so
totalpages = total_ram,
get_mm_counter(p->mm, MM_SWAPENTS) = 0,

so
points = (get_mm_rss(p->mm)) * 1000 / totalpages;

so points canot larger than 1000.




>
>
>
> Thanks,
> -Kame
>
>

