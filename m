Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1CHTCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:02:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1CHTCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:02:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aVCvGK/0efAu7zqyE4uKQs4UYj8/0Sw0YkhGHQTYx/9VJp7UgqmBgxf2159dcEDCuK
         gPmAStVQvdElFQa8LHsWuIuZ+rBFn6B+woE0pERqpfdoGAkg3NuCkA/uEtfzys4F0whM
         2/mjWy+bRyjmpkJERXQCbJL3Fzd8ITycDT1aE=
Message-ID: <4D767D43.5020802@gmail.com>
Date: Tue, 08 Mar 2011 22:02:27 +0300
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
References: <20110307135831.9e0d7eaa.akpm@linux-foundation.org> <20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com> <20110308120615.7EB9.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110308120615.7EB9.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 06:06 AM, KOSAKI Motohiro wrote:
>>>> Hmm.. Although it solves the problem, I think it's not a good idea that
>>>> depends on false alram and give up the retry.
>>>
>>> Any alternative proposals?  We should get the livelock fixed if possible..
>>
>> I agree with Minchan and can't think this is a real fix....
>> Andrey, I'm now trying your fix and it seems your fix for oom-killer,
>> 'skip-zombie-process' works enough good for my environ.
>>
>> What is your enviroment ? number of cpus ? architecture ? size of memory ?
>
> me too. 'skip-zombie-process V1' work fine. and I didn't seen this patch
> improve oom situation.
>
> And, The test program is purely fork bomb. Our oom-killer is not silver
> bullet for fork bomb from very long time ago. That said, oom-killer send
> SIGKILL and start to kill the victim process. But, it doesn't prevent
> to be created new memory hogging tasks. Therefore we have no gurantee
> to win process exiting and creating race.

I think a live-lock is a bug, even if it's provoked by fork bomds.

And now I want say some words about zone->all_unreclaimable. I think 
this flag is "conservative". It is set when situation is bad and it's 
unset when situation get better. If we have a small number of 
reclaimable  pages, the situation is still bad. What do you mean, when 
say that kernel is alive? If we have one reclaimable page, is the kernel 
alive? Yes, it can work, it will generate many page faults and do 
something, but anyone say that it is more dead than alive.

Try to look at it from my point of view. The patch will be correct and 
the kernel will be more alive.

Excuse me, If I'm mistaken...


>
> *IF* we really need to care fork bomb issue, we need to write completely
> new VM feature.
>
>

