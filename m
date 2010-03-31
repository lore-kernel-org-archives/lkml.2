Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0CaL2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 07:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab0CaL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 07:28:14 -0400
Date: Wed, 31 Mar 2010 13:25:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to
	destroy_workqueue()
Message-ID: <20100331112559.GA17747@redhat.com>
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331105534.5601.50813.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Amerigo Wang wrote:
>
> This fixes a lockdep warning when invoking destroy_workqueue(),
> because the lockdep annotations are invoked under cpu_add_remove_lock.

Confused. Why does lockdep complains?

> So, move the lockdep annotations before taking cpu_add_remove_lock
> in destroy_workqueue(), this will not affect the original purpose
> of adding them for destroy_workqueue() etc.
>
> However, it will affect another caller of cleanup_workqueue_thread(),
> that is, workqueue_cpu_callback(). This should be fine, because there
> are no other cases than cpu hotplug could call it.

OK, but nobody should take cpu_maps_update_begin() under wq->lockdep_map,
in particular work->func() must not.

I must have missed something, but it seems to me this patch tries to
supress the valid warning.

Could you please clarify?

Oleg.

