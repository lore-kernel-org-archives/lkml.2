Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2IZSii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:38:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62651 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2IZSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:38:37 -0400
Date: Wed, 26 Sep 2012 11:38:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12] workqueue: add WQ_CPU_INTENSIVE to
 system_long_wq
Message-ID: <20120926183833.GI12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-12-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-12-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:42AM +0800, Lai Jiangshan wrote:
> works in system_long_wq will be running long.
> add WQ_CPU_INTENSIVE to system_long_wq to avoid these kinds of works occupy
> the running wokers which delay the normal works.
> 
> if system_long_wq is designed for only sleep-long works, not running-long works,
> this patch makes no sense.

There "long" doesn't mean it's gonna consume a lot of CPU cycles, so
it should contribute to concurrency management.  The plan is to remove
system_long_wq once we got rid of flushing of system_wq via
flush_scheduled_work() and directly through flush_workqueue().  I
think we're pretty close, so let's not add more usage of it.

Thanks.

-- 
tejun
