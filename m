Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2IRJik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:38:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3300 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab2IRJij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:38:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,442,1344182400"; 
   d="scan'208";a="5864537"
Message-ID: <5058419A.5050904@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 17:40:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [V2 for-next PATCH 0/7] workqueue: async idle rebinding and cleanup
 for hotplug
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 17:38:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 17:38:55,
	Serialize complete at 2012/09/18 17:38:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 11:46 PM, Lai Jiangshan wrote:
> Patch1 fix new found possible bug.
> 
> Patch2 use async algorithm to replace the synchronous algorithm to rebind
> idle workers.
> 
> The synchronous algorithm requires 3 hand shakes, it introduces much
> complicated. 
> 
> The new async algorithm does not do any synchronization. it removes
> the idle workers from idle_list to ensure the local-wake-up is correct
> instead.
> 
> Patch3-7 do simple cleanup
> 
> Patch2-7 are ready for for-next. I have other devlopment and cleanup for workqueue,
> should I wait this patchset merged or send them at the same time?

Hello, Tejun:

Please defer Patch3-7, because they conflict with the merged one.

Could you please review and merge the the Patch2(async idle rebinding).
I have made some effort to write/review/check it.

Thanks,
Lai

> 
> Lai Jiangshan (7):
>   workqueue: clear WORKER_REBIND unconditionaly in
>     busy_worker_rebind_fn()
>   workqueue: async idle rebinding
>   workqueue: new day don't need WORKER_REBIND for busy rebinding
>   workqueue: remove WORKER_REBIND
>   workqueue: rename manager_mutex to assoc_mutex
>   workqueue: use __cpuinit instead of __devinit for cpu callback
>   workqueue: use hotcpu_notifier() for workqueue_cpu_down_callback()
> 
>  kernel/workqueue.c |  228 ++++++++++++++++++---------------------------------
>  1 files changed, 81 insertions(+), 147 deletions(-)
> 

