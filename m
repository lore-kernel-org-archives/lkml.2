Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1FFDHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:07:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59424 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab1FFDHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:07:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEC4463.1060206@jp.fujitsu.com>
Date: Mon, 06 Jun 2011 12:07:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: caiqian@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <348391538.318712.1306828778575.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4DE4A2A0.6090704@jp.fujitsu.com> <4DE4BC64.3040807@jp.fujitsu.com> <20110601033258.GA12653@barrios-laptop>
In-Reply-To: <20110601033258.GA12653@barrios-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Of course, we recommend to drop privileges as far as possible
>> instead of keeping them. Thus, oom killer don't have to check
>> any capability. It implicitly suggest wrong programming style.
>>
>> This patch change root process check way from CAP_SYS_ADMIN to
>> just euid==0.
> 
> I like this but I have some comments.
> Firstly, it's not dependent with your series so I think this could
> be merged firstly.

I agree.

> Before that, I would like to make clear my concern.
> As I look below comment, 3% bonus is dependent with __vm_enough_memory's logic?

No. completely independent.

vm_enough_memory() check the task _can_ allocate more memory. IOW, the task
is subjective. And oom-killer check the task should be protected from oom-killer.
IOW, the task is objective.


> If it isn't, we can remove the comment. It would be another patch.
> If is is, could we change __vm_enough_memory for euid instead of cap?
> 
>         * Root processes get 3% bonus, just like the __vm_enough_memory()
> 	* implementation used by LSMs.

vm_enough_memory() is completely correct. I don't see any reason to change it.


