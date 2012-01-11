Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2AKQie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:38:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35244 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2AKQid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:38:33 -0500
Date: Wed, 11 Jan 2012 08:38:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org, winget@google.com,
        namhyung@gmail.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 8/9] stacktrace: implement save_stack_trace_quick()
Message-ID: <20120111163826.GC26832@google.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
 <1326220106-5765-9-git-send-email-tj@kernel.org>
 <20120111162642.GC7991@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111162642.GC7991@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Wed, Jan 11, 2012 at 05:26:44PM +0100, Frederic Weisbecker wrote:
> On Tue, Jan 10, 2012 at 10:28:25AM -0800, Tejun Heo wrote:
> > Implement save_stack_trace_quick() which only considers the usual
> > contexts (ie. thread and irq) and doesn't handle links between
> > different contexts - if %current is in irq context, only backtrace in
> > the irq stack is considered.
> 
> The thing I don't like is the duplication that involves not only on
> stack unwinding but also on the safety checks.

I'm not entirely convinced that this is necessary or we can just add
more features to the existing backtrace facility (and maybe make that
more efficient) and be done with it.

> > This is subset of dump_trace() done in much simpler way.  It's
> > intended to be used in hot paths where the overhead of dump_trace()
> > can be too heavy.
> 
> Is it? Have you found a measurable impact (outside the fact you record only
> one stack).

As I wrote in the head message, I haven't done comparative test yet
but in the preliminary tests the CPU overhead against memory backed
device is quite visible (roughly ~20%), so I expect it to matter.
Note that testing against memory backed device is actually relevant,
on faster SSDs, CPU is already a bottleneck.

It would be best if we can extend the existing one to cover all the
cases with acceptable overhead.  I needed to write this minimal
version anyway for comparison so it's posted together but no matter
how it turns out switching them isn't difficult.

Thanks.

-- 
tejun
