Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2BGGug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:50:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab2BGGub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:50:31 -0500
Message-ID: <4F30C96F.1000905@kernel.dk>
Date: Tue, 07 Feb 2012 07:49:19 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
References: <1328514611.21268.66.camel@sli10-conroe> <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk> <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com> <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com> <20120206172706.GB21292@google.com> <4F303506.9000201@kernel.dk> <20120206215451.GD21292@google.com>
In-Reply-To: <20120206215451.GD21292@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 10:54 PM, Tejun Heo wrote:
> put_io_context() performed a complex trylock dancing to avoid
> deferring ioc release to workqueue.  It was also broken on UP because
> trylock was always assumed to succeed which resulted in unbalanced
> preemption count.
> 
> While there are ways to fix the UP breakage, even the most
> pathological microbench (forced ioc allocation and tight fork/exit
> loop) fails to show any appreciable performance benefit of the
> optimization.  Strip it out.  If there turns out to be workloads which
> are affected by this change, simpler optimization from the discussion
> thread can be applied later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> LKML-Reference: <1328514611.21268.66.camel@sli10-conroe>
> ---
> I couldn't find any statiscally meaningful advantage of the
> optimization with tight fork/exit tests w/ forced ioc creation on
> fork, which gotta be the most pathological test case for the code
> path.  So, let's remove the ugly optimization.  If I missed sth, we
> can resurrect the simpler optimization later.  Jens, this is on top of
> linus#master without Shaohua's patch.

OK, then I'm fine with cleaning it up. Applied, thanks Tejun.

-- 
Jens Axboe

