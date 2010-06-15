Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab0FOS35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:29:57 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40611 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0FOS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:29:56 -0400
X-Greylist: delayed 797 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 14:29:56 EDT
Message-ID: <4C17C671.3020605@s5r6.in-berlin.de>
Date: Tue, 15 Jun 2010 20:29:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.24) Gecko/20100228 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
In-Reply-To: <1276551467-21246-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This is the fifth take of cmwq (concurrency managed workqueue)
> patchset.  It's on top of v2.6.35-rc3 + sched/core patches.  Git tree
> is available at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

A comment and a question:

As a driver maintainer, I would find it helpful if the WQ_flags in
include/linux/workqueue.h and/or __create_workqueue_key() in
kernel/workqueue.c (or its wrappers in include/linux/workqueue.h) were
better documented.

How about the global workqueue, i.e. schedule_work() and friends?  At
your current review-cmwq head, they use system_wq, not system_nrt_wq.
But doesn't have the present global workqueue WQ_NON_REENTRANT
semantics?  In fact, don't have _all_ workqueues WQ_NON_REENTRANT
semantics presently?  If so, a good deal of existing users probably
relies on non-reentrant behaviour.  Or am I thoroughly misunderstanding
the meaning of WQ_NON_REENTRANT?

(Sorry if this had been discussed before; I followed the discussions of
some of your previous submissions but not all.  And PS, I am eagerly
awaiting for this to go into the mainline.)
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/
