Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab0EYVKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:10:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57357 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab0EYVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:10:32 -0400
Subject: Re: Tracing configuration review
From: Chase Douglas <chase.douglas@canonical.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
In-Reply-To: <20100525201259.GA5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	 <20100525201259.GA5370@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 17:09:59 -0400
Message-ID: <1274821799.9346.17.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 22:13 +0200, Frederic Weisbecker wrote:
> On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:
> > The following options are what I am looking to set for our x86
> > configurations. I've only included those that I am not 100% sure of.
> > Comments are what I could gather from documentation and Kconfig, but
> > they may not be accurate:

<snip>

> > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> 
> 
> We want to deprecate it in the long term, but for now we
> don't have any replacement. Cool for RT latency tracing.

I thought that the functionality is the same as what you get by:

echo 1 > (debufs)/tracing/events/sched/enable

> > CONFIG_KSYM_TRACER=y (no performance impact by default)
> 
> 
> IMO, it is deprecated. The perf interface is much more powerful and flexible.
> Prasad, do you agree if I remove this ftrace plugin?

If there isn't any use in enabling it due to perf's features, then we
can turn it off. However, if there's any use to be gained by this over
perf's features, then I'd prefer to leave it on. Thoughts?


> > CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)
> 
> 
> In the way for deprecation.

Is this like the KMEM_TRACER where trace events have superseded it?

Thanks,

-- Chase

