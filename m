Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0ESGVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:21:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0ESGVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:21:45 -0400
Subject: Re: schedule() && prev/current (Was: [PATCH 3/3] Make
 get_current() __attribute__((const)))
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Yong Zhang <yong.zhang0@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100518212220.GA5092@redhat.com>
References: <20100518164537.6194.73366.stgit@warthog.procyon.org.uk>
	 <20100518164547.6194.94193.stgit@warthog.procyon.org.uk>
	 <20100518212220.GA5092@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 08:21:19 +0200
Message-ID: <1274250079.5605.9967.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 23:22 +0200, Oleg Nesterov wrote:

> And, looking at this patch I think that schedule() can be simplified
> a little bit.
> 
> "sched: Reassign prev and switch_count when reacquire_kernel_lock() fail"
> commit 6d558c3ac9b6508d26fd5cadccce51fc9d726b1c says:
> 
> 	Assume A->B schedule is processing,
> 	...
> 	Then on B's context,
> 	...
> 	prev and switch_count are related to A
> 
> How so? switch_count - yes, we should change it. But prev must be
> equal to B, and it must be equal to current. When we return from
> switch_to() registers/stack should be restored correctly, so we
> can do

What if schedule() got called at a different stack depth than we are
now?

I don't think we can assume anything about the stack context we just
switched to.
