Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3AEWOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 17:14:49 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:34002 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3AEWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 17:14:47 -0500
Date: Sat, 5 Jan 2013 14:11:15 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 01/25] charger_manager: don't use [delayed_]work_pending()
Message-ID: <20130105221115.GC1246@lizard.mcd00620.sjc.wayport.net>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1356141435-17340-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 05:56:51PM -0800, Tejun Heo wrote:
> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests and rewrite _setup_polling() so that
> it uses mod_delayed_work() if the next polling interval is sooner than
> currently scheduled.  queue_delayed_work() is used otherwise.
> 
> Only compile tested.  I noticed that two work items - setup_polling
> and cm_monitor_work - schedule each other.  It's a very unusual
> construct and I'm fairly sure it's racy.  You can't break such
> circular dependency by calling cancel on each.  I strongly recommend
> revising the mechanism.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

Charger manager is a fast moving target, so it is prone to conflict; it is
better if I take it via battery-2.6.git tree. It is merged, thanks a lot!

Anton
