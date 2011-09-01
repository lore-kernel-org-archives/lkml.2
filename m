Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab1IAKAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:00:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58501 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1IAKAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:00:07 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 01 Sep 2011 12:00:01 +0200
In-Reply-To: <4E5F45F6.70009@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
			 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
		 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
	 <1314863829.7945.9.camel@twins> <4E5F45F6.70009@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314871201.7945.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 16:44 +0800, Huang Ying wrote:

> Because llist is in library, it may be used in highly contended case and
> light/un-contended loads.  So maybe code as above is best choice for llist.

Well the thing is, if you're heavily contended you should probably be
doing something else..

> > Also, just noticed, why do you have different list_head/list_node
> > structures? They're the same, a single pointer.
> 
> There is only one structure before (llist_head).  Linus give me some
> comments about that, suggests to use 2 structures.  I think his comments
> are reasonable.  Copied here:

OK

> Even with this_cpu_* ops, it seems that the race condition I described
> is still possible.
> 
> - use this_cpu_cmpxchg to queue irq_work into irq_work_list of CPU A
> - preempted and resumed execution on CPU B
> - arch_irq_work_raise on CPU B
> 
> Do you think so?

No you're right, got my brain inside-out today or so..
