Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3AIWww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:52:52 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:41822 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156Ab3AIWwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:52:51 -0500
X-Remote-IP: 213.191.128.133
Date: Wed, 09 Jan 2013 23:52:47 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <50EDE41C.7090107@iskon.hr> <20130109134816.db51a820.akpm@linux-foundation.org>
In-Reply-To: <20130109134816.db51a820.akpm@linux-foundation.org>
Message-ID: <50EDF4BF.7000108@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: wait for congestion to clear on all zones
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130110 #9042073, check: 20130109 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 41238 [Jan 10 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.01.2013 22:48, Andrew Morton wrote:
> On Wed, 09 Jan 2013 22:41:48 +0100
> Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:
>
>> Currently we take a short nap (HZ/10) and wait for congestion to clear
>> before taking another pass with lower priority in balance_pgdat(). But
>> we do that only for the highest zone that we encounter is unbalanced
>> and congested.
>>
>> This patch changes that to wait on all congested zones in a single
>> pass in the hope that it will save us some scanning that way. Also we
>> take a nap as soon as congested zone is encountered and sc.priority <
>> DEF_PRIORITY - 2 (aka kswapd in trouble).
>>
>> ...
>>
>> The patch is against the mm tree. Make sure that
>> mm-avoid-calling-pgdat_balanced-needlessly.patch is applied first (not
>> yet in the mmotm tree). Tested on half a dozen systems with different
>> workloads for the last few days, working really well!
>
> But what are the user-observable effcets of this change?  Less kernel
> CPU consumption, presumably?  Did you quantify it?
>

And I forgot to answer all the questions... :(

Actually, I did record kswapd CPU usage after 5 days of uptime and I 
intend to compare it with the new data (after few more days pass). I 
expect maybe slightly better results.

But, I think it's obvious from my first reply that my primary goal with 
this patch is correctness, not optimization. So, I won't be dissapointed 
a little bit if kswapd CPU usage stays the same, so long as the memory 
utilization remains this smooth. ;)

-- 
Zlatko
