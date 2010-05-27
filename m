Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0E0Gv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:51:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab0E0Gv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:51:27 -0400
Date: Wed, 26 May 2010 23:51:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
Message-Id: <20100526235107.77e66ce0.akpm@linux-foundation.org>
In-Reply-To: <1274942798.27810.3584.camel@twins>
References: <4BF9EC69.5030709@example.com>
	<1274777422.5882.591.camel@twins>
	<20100526160252.325f8357.akpm@linux-foundation.org>
	<1274942798.27810.3584.camel@twins>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 08:46:38 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 16:02 -0700, Andrew Morton wrote:
> 
> > How is anyone supposed to use this?  What are the semantics of this
> > thing?  What are the units of its return value?  What is the base value
> > of its return value?  Does it return different times on different CPUs?
> > I assume so, otherwise why does sched_clock_cpu() exist?  <looks at
> > the sched_clock_cpu() documentation, collapses in giggles>
> 
> The point of the whole sched_clock_cpu() thing is to provide a fairly
> high resolution clock with bounded drift between cpus.
> 
> It also promises to be monotonic per cpu argument, that is,
> sched_clock_cpu(j) will, for a constant j always return a monotonic
> increasing timestamp.
> 
> It doesn't make much promises about its base (although people tend to
> want it to start at 0 on boot, but the users really shouldn't care).
> 
> sched_clock() doesn't promise either bounded drift between cpus nor
> monotonicity.
> 

OK, well please document these subtleties things in a very obvious place.

Right now the code is a landmine.  Some poor innocent drivers/foo/
developer can use them and add fantastically subtle
once-per-million-machine-year lockup-causing bugs which he'll never be
able to diagnose.

