Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab0FRRDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:03:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933745Ab0FRRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:03:33 -0400
Date: Fri, 18 Jun 2010 10:02:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100618100228.093ec17b.akpm@linux-foundation.org>
In-Reply-To: <4C1B29BF.7080404@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
	<20100617161619.d3ebd73d.akpm@linux-foundation.org>
	<4C1B1D3F.8030509@kernel.org>
	<20100618003127.10d9e6c8.akpm@linux-foundation.org>
	<4C1B29BF.7080404@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 10:09:35 +0200 Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 06/18/2010 09:31 AM, Andrew Morton wrote:
> > On Fri, 18 Jun 2010 09:16:15 +0200 Tejun Heo <tj@kernel.org> wrote:
> > Nope.  Consider a simple byte-at-a-time rx handler.  The ISR grabs the
> > byte, stashes it away, bangs on the hardware a bit then signals
> > userspace to promptly start processing that byte.  Very simple,
> > legitimate and a valid thing to do.
> > 
> > Also the "interrupt" code might be running from a timer handler.  Or it
> > might just be in process context, buried in a forest of locks and wants
> > to punt further processing into a separate process.
> 
> Sure, there'll be cases which would be better served that way but
> things which fit neither the traditional interrupt handler nor the
> threaded one are in very small minority.  I think having niche
> solutions for those niche problems would be far better than trying to
> engineer generic async mechanism to serve all of them.

um.  We've *already* engineered a mechanism which serves the
requirements which we've been discussing.  Then Tejun came along,
called it "niche" and busted it!

Oh well.  Kernel threads should not be running with RT policy anyway. 
RT is a userspace feature, and whenever a kernel thread uses RT it
degrades userspace RT qos.  But I expect that using RT in kernel
threads is sometimes the best tradeoff, so let's not pretend that we're
getting something for nothing here!
