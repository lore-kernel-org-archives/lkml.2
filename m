Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2IEBdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:33:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57882 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2IEBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:33:52 -0400
Date: Tue, 4 Sep 2012 18:33:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10 V4] workqueue: fix deadlock in rebind_workers()
Message-ID: <20120905013347.GF2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-3-git-send-email-laijs@cn.fujitsu.com>
 <20120905005409.GB2836@dhcp-172-17-108-109.mtv.corp.google.com>
 <5046AAC6.7010704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5046AAC6.7010704@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 05, 2012 at 09:28:38AM +0800, Lai Jiangshan wrote:
> I see that this patch's idea is same as mine but reuses
> @idle_rebind.cnt and @idle_rebind.done.
> 
> I don't think it is consistent to avoid adding new field
> and to reuse old field for different purpose

It's not necessarily the reuse which seems more consistent to me but
where the driving logic is.  It's now better contained in
rebind_workers().

> > -	/*
> > -	 * All idle workers are rebound and waiting for %WORKER_REBIND to
> > -	 * be cleared inside idle_worker_rebind().  Clear and release.
> > -	 * Clearing %WORKER_REBIND from this foreign context is safe
> > -	 * because these workers are still guaranteed to be idle.
> > -	 */
> > -	for_each_worker_pool(pool, gcwq)
> > -		list_for_each_entry(worker, &pool->idle_list, entry)
> > -			worker->flags &= ~WORKER_REBIND;
> > -
> > -	wake_up_all(&gcwq->rebind_hold);
> 
> don't need to move down.

Yeap, but cleaner that way.  With the moving separated into another
patch, the addition of another handshake stage becomes easier to
follow.

Thanks.

-- 
tejun
