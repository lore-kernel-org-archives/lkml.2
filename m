Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946465Ab2LFSNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:13:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37489 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2LFSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:13:17 -0500
Date: Thu, 6 Dec 2012 10:13:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>,
        Peter Zijlstra <pzijlstr@redhat.com>, Ingo <mingo@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
Message-ID: <20121206181310.GR19802@htj.dyndns.org>
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
 <50BE5988.3050501@fusionio.com>
 <x498v9dpnwu.fsf@segfault.boston.devel.redhat.com>
 <50BE5C99.6070703@fusionio.com>
 <x494nk1pi7h.fsf@segfault.boston.devel.redhat.com>
 <20121206180150.GQ19802@htj.dyndns.org>
 <x494njzxdd9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494njzxdd9.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 06, 2012 at 01:08:18PM -0500, Jeff Moyer wrote:
> > As for the original patch, I think it's a bit too much to expose to
> > userland.  It's probably a good idea to bind the flusher to the local
> > node but do we really need to expose an interface to let userland
> > control the affinity directly?  Do we actually have a use case at
> > hand?
> 
> Yeah, folks pinning realtime processes to a particular cpu don't want
> the flusher threads interfering with their latency.  I don't have any
> performance numbers on hand to convince you of the benefit, though.

What I don't get is, RT tasks win over bdi flushers every time and I'm
skeptical allowing bdi or not on a particular CPU would make a big
difference on non-RT kernels anyway.  If the use case calls for
stricter isolation, there's isolcpus.  While I can see why someone
might think that they need something like this, I'm not sure it's
actually something necessary.

And, even if it's actually something necessary, I think we'll probably
be better off with adding a mechanism to notify userland of new
kthreads and let userland adjust affinity using the usual mechanism
rather than adding dedicated knobs for each kthread users.

Thanks.

-- 
tejun
