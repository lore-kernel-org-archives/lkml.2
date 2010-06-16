Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab0FPTqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:46:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39628 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab0FPTqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:46:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6015"; a="44643282"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C192404.7000004@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org> <1276701074.9309.60.camel@m0nster>
	 <4C18F2B8.9060805@kernel.org> <1276705838.9309.94.camel@m0nster>
	 <4C1901E9.2080907@kernel.org> <1276712547.9309.172.camel@m0nster>
	 <4C191BE9.1060400@kernel.org>  <4C192404.7000004@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 12:46:16 -0700
Message-ID: <1276717576.9309.218.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 21:20 +0200, Tejun Heo wrote:
> On 06/16/2010 08:46 PM, Tejun Heo wrote:
> > * I'm very sorry I'm breaking your hacky workaround but seriously
> >   that's another problem to solve.  Let's talk about the problem
> >   itself instead of your hacky workaround.  (I think for most cases
> >   not using workqueue in RT path would be the right thing to do.)
> 
> For example, for the actual case of amba-pl022.c you mentioned, where
> interrupt handler sometimes offloads to workqueue, convert
> amba-pl022.c to use threaded interrupt handler.  That's why it's
> there.
> 
> If you actually _solve_ the problem like this, other users wouldn't
> experience the problem at all once the update reaches them and you
> won't have to worry about your workaround breaking with the next
> kernel update or unexpected suspend/resume and we won't be having this
> discussion about adjusting workqueue priorities from userland.

What you suggesting just means the user has to adjust an interrupt
thread instead of a workqueue thread. That really doesn't change
anything, since it's just another type of kernel thread.

> There are many wrong things about working around RT latency problems
> by setting workqueue priorities from userland.  Please think about why
> the driver would have a separate workqueue for itself in the first
> place.  It was to work around the limitation of workqueue facility and
> you're arguing that, because that work around allows yet another very
> fragile workaround, the property which made the original work around
> necessary in the first place needs to stay.  That sounds really
> perverse to me.

I have no idea what your trying to say here.. I'm sure there is no one
reason why people use workqueues in their drivers. In fact I'm sure
there are many reasons to use workqueues or not to use them.

Daniel

