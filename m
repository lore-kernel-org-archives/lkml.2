Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2H2SVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:21:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38161 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2H2SVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:21:04 -0400
Date: Wed, 29 Aug 2012 11:21:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9 V3] workqueue: add POOL_MANAGING_WORKERS
Message-ID: <20120829182102.GA2258@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com>
 <1346259120-6216-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346259120-6216-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Aug 30, 2012 at 12:51:54AM +0800, Lai Jiangshan wrote:
> When hotplug happens, the plug code will also grab the manager_mutex,
> it will break too_many_workers()'s assumption, and make too_many_workers()
> ugly(kick the timer wrongly, no found bug).
> 
> To avoid assumption-coruption, we add the original POOL_MANAGING_WORKERS back.

I don't think we're gaining anything with this and I'd like to confine
management state within the mutex only.  If too_many_workers() firing
spuriously while CPU up/down is in progress, just add a comment
explaining why it's a non-problem (actual worker management never
happens while cpu up/down holds manager positions).

Thanks.

-- 
tejun
