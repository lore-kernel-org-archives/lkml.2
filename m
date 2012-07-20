Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2GTRn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:43:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42101 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2GTRn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:43:26 -0400
Date: Fri, 20 Jul 2012 10:43:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720174321.GH32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342802391.2583.11.camel@twins>
 <20120720165213.GD32763@google.com>
 <1342803700.2583.29.camel@twins>
 <20120720170802.GF32763@google.com>
 <1342804767.2583.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342804767.2583.40.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Fri, Jul 20, 2012 at 07:19:27PM +0200, Peter Zijlstra wrote:
> > Hmmm?  Not really.  We need to keep count of the ones which reqested
> > fixed binding - ie. the ones which explicitly used queue_work_on() -
> > and then flush on wq CPU_DOWN.  Then, we need to audit the current
> > users which are using queue_work{_on}() + explicit FLUSH on CPU_DOWN
> > and convert them.
> 
> No, that's the wrong way about. Just add another WQ_flag, so you can
> tell which work-queues want sane semantics and those mucking about for
> laughs, say WQ_NON_AFFINE.
> 
> Then those with sane semantics (!WQ_NON_AFFINE) get an explicit flush on
> DOWN and don't need to muck about with detaching and re-attaching etc..

Two things - 1. I'd prefer the CPU-affinity requirement to be explicit
at the callsite.  2. To implement it the way you describe, we would
have to implement per-cpu workqueue flush, which is possible but I
don't wanna complicate flush_workqueue() implementation anymore than
it already is.  It's a still a relatively cold exception path.  No
need to complicate the usual path with it.

Thanks.

-- 
tejun
