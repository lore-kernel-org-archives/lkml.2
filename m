Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2H2SZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:25:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2H2SZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:25:11 -0400
Date: Wed, 29 Aug 2012 11:25:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9 V3] workqueue: add
 non_manager_role_manager_mutex_unlock()
Message-ID: <20120829182510.GB2258@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
 <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 12:51:55AM +0800, Lai Jiangshan wrote:
> If hotplug code grabbed the manager_mutex and worker_thread try to create
> a worker, the manage_worker() will return false and worker_thread go to
> process work items. Now, on the CPU, all workers are processing work items,
> no idle_worker left/ready for managing. It breaks the concept of workqueue
> and it is bug.
> 
> So when this case happens, the last idle should not go to process work,
> it should go to sleep as usual and wait normal events. but it should
> also be notified by the event that hotplug code release the manager_mutex.
> 
> So we add non_manager_role_manager_mutex_unlock() to do this notify.

Hmmm... how about just running rebind_workers() from a work item?
That way, it would be guaranteed that there alwyas will be an extra
worker available on rebind completion.

Thanks.

-- 
tejun
