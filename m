Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab1EKQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:46:40 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:53894 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab1EKQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:46:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCA40E8.3090805@jp.fujitsu.com>
Date: Wed, 11 May 2011 16:55:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 01/15] sched: (fixlet) dont update shares twice on on_rq
 parent
References: <20110503092846.022272244@google.com>	 <20110503092904.541414484@google.com>  <4DC8E5C2.9090701@jp.fujitsu.com> <1305016326.14565.2.camel@marge.simson.net>
In-Reply-To: <1305016326.14565.2.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/10 17:32), Mike Galbraith wrote:
> On Tue, 2011-05-10 at 16:14 +0900, Hidetoshi Seto wrote:
>> This small fixlet can stand alone.
>> Peter, how about getting this into git tree first?
> 
> tip 2f36825b176f67e5c5228aa33d828bc39718811f contains the below.
> 
>                 /* Don't dequeue parent if it has other entities besides us */
> -               if (cfs_rq->load.weight)
> +               if (cfs_rq->load.weight) {
> +                       /*
> +                        * Bias pick_next to pick a task from this cfs_rq, as
> +                        * p is sleeping when it is within its sched_slice.
> +                        */
> +                       if (task_sleep && parent_entity(se))
> +                               set_next_buddy(parent_entity(se));
>                         break;
> +               }
>                 flags |= DEQUEUE_SLEEP;
>         }

Oh, thanks Mike!
It seems that this change in tip is better one.

Paul, don't you mind rebasing your patches onto tip/sched/core next time?
(...or is there better branch for rebase?)


Thanks,
H.Seto

