Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab2IZSMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:12:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2IZSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:12:34 -0400
Date: Wed, 26 Sep 2012 11:12:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, tangchen <tangchen@cn.fujitsu.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/12] workqueue: disallow set_cpus_allowed_ptr() from
 work item
Message-ID: <20120926181230.GC12544@google.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348680043-5077-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:20:33AM +0800, Lai Jiangshan wrote:
> workers depend on local-wake-up, if a work function change its CPU, it will
> corrupt workqueue, disallow this behavior.
> 
> When set_cpus_allowed_ptr() is called from workqueue.c in worker_thread(),
> we clear the PF_WQ_WORKER before set_cpus_allowed_ptr() and set it back
> after. (rescuer thread has no PF_WQ_WORKER, skip this behavior)
> 
> It prevents other/future BUGs like https://bugzilla.kernel.org/show_bug.cgi?id=47301.

Hmmm... maybe.  We better clear up PF_THREAD_BOUND semantics first
tho.

I think the two possible choices are,

* Don't allow set_cpus_allowed_ptr() at all and make the caller
  responsible for turning it off if it explicitly wants to change
  cpus_allowed.

* Don't allow changing affinity from userland.

Peter, Thomas?

-- 
tejun
