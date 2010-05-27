Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0E0Gqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:46:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:42649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0E0Gqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:46:44 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>
In-Reply-To: <20100526160252.325f8357.akpm@linux-foundation.org>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100526160252.325f8357.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 08:46:38 +0200
Message-ID: <1274942798.27810.3584.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 16:02 -0700, Andrew Morton wrote:

> How is anyone supposed to use this?  What are the semantics of this
> thing?  What are the units of its return value?  What is the base value
> of its return value?  Does it return different times on different CPUs?
> I assume so, otherwise why does sched_clock_cpu() exist?  <looks at
> the sched_clock_cpu() documentation, collapses in giggles>

The point of the whole sched_clock_cpu() thing is to provide a fairly
high resolution clock with bounded drift between cpus.

It also promises to be monotonic per cpu argument, that is,
sched_clock_cpu(j) will, for a constant j always return a monotonic
increasing timestamp.

It doesn't make much promises about its base (although people tend to
want it to start at 0 on boot, but the users really shouldn't care).

sched_clock() doesn't promise either bounded drift between cpus nor
monotonicity.


