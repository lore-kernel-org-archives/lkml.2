Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3AIJ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:29:14 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35829 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3AIJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:29:00 -0500
Message-ID: <50ED384C.1030301@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 17:28:44 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
In-Reply-To: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010909-5564-0000-0000-0000061FA5C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 02:08 PM, Michael Wang wrote:
> This patch set is trying to simplify the select_task_rq_fair() with
> schedule balance map.
> 
> After get rid of the complex code and reorganize the logical, pgbench show
> the improvement.
> 
> 	Prev:
> 		| db_size | clients |  tps  |
> 		+---------+---------+-------+
> 		| 22 MB   |       1 |  4437 |
> 		| 22 MB   |      16 | 51351 |
> 		| 22 MB   |      32 | 49959 |
> 		| 7484 MB |       1 |  4078 |
> 		| 7484 MB |      16 | 44681 |
> 		| 7484 MB |      32 | 42463 |
> 		| 15 GB   |       1 |  3992 |
> 		| 15 GB   |      16 | 44107 |
> 		| 15 GB   |      32 | 41797 |
> 
> 	Post:
> 		| db_size | clients |  tps  |
> 		+---------+---------+-------+
> 		| 22 MB   |       1 | 11053 |		+149.11%
> 		| 22 MB   |      16 | 55671 |		+8.41%
> 		| 22 MB   |      32 | 52596 |		+5.28%
> 		| 7483 MB |       1 |  8180 |		+100.59%
> 		| 7483 MB |      16 | 48392 |		+8.31%
> 		| 7483 MB |      32 | 44185 |		+0.18%
> 		| 15 GB   |       1 |  8127 |		+103.58%
> 		| 15 GB   |      16 | 48156 |		+9.18%
> 		| 15 GB   |      32 | 43387 |		+3.8%
> 
> Please check the patch for more details about schedule balance map, they
> currently based on linux-next 3.7.0-rc6, will rebase them to tip tree in
> follow version.
> 
> Comments are very welcomed.

Could I get some comments for this patch set?

Regards,
Michael Wang

> 
> Test with:
> 	12 cpu X86 server and linux-next 3.7.0-rc6.
> 
> Michael Wang (2):
> 	[PATCH 1/2] sched: schedule balance map foundation
> 	[PATCH 2/2] sched: simplify select_task_rq_fair() with schedule balance map
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  core.c  |   61 +++++++++++++++++++++++++++++
>  fair.c  |  133 +++++++++++++++++++++++++++++++++-------------------------------
>  sched.h |   28 +++++++++++++
>  3 files changed, 159 insertions(+), 63 deletions(-)
> 

