Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2H2Set (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:34:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42669 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2H2Ses (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:34:48 -0400
Date: Wed, 29 Aug 2012 11:34:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9 V3] workqueue: explicit way to wait for idles
 workers to finish
Message-ID: <20120829183447.GC2258@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
 <1346259120-6216-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346259120-6216-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 30, 2012 at 12:51:58AM +0800, Lai Jiangshan wrote:
> busy_worker_rebind_fn() can't return until all idle workers are rebound.
> This order is ensured by rebind_workers() currently.
> 
> We use mutex_lock(&worker->pool->manager_mutex) to wait for all idle workers
> to be rebound. this is an explicit way and it will ease the pain of
> the rebind_workers().
> 
> The sleeping mutex_lock(&worker->pool->manager_mutex) must be put in the top of
> busy_worker_rebind_fn(), because this busy worker thread can sleep
> before the WORKER_REBIND is cleared, but can't sleep after
> the WORKER_REBIND cleared.

I really can't say I like this overloading of manager_mutex.  CPU
up/down are actually behaving like the manager while it's holding the
manager_mutex at least.  I don't really think this
non-manager-role-manager-mutex usage is worthwhile whatever
simplification it makes to rebind path.  Rebind path being a bit ugly
/ complex is better than it muddling non-cpu-hotplug path further.

Thanks.

-- 
tejun
