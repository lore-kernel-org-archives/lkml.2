Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0FOQni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:43:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:45657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470Ab0FOQnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:43:37 -0400
Message-ID: <4C17AD76.2010707@kernel.org>
Date: Tue, 15 Jun 2010 18:42:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk,
       Anton Blanchard <anton@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 27/30] workqueue: implement DEBUGFS/workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <1276551467-21246-28-git-send-email-tj@kernel.org> <20100615135432.GF5342@nowhere>
In-Reply-To: <20100615135432.GF5342@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 16:42:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 03:54 PM, Frederic Weisbecker wrote:
> I don't like this. This adds 300 lines of ad hoc in-kernel
> instrumentation code while we now have a nice kernel tracing API
> (trace events) coupled with easy userspace tools to post-process
> that (perf trace scripting). And this is going to provide a much
> more powerful view of your new workqueue implementation runtime
> behaviour.
>
> We already have kernel/trace/trace_workqueue.c that has been
> obsolated for these very reasons and we are even going to remove it
> soon, probably for .36
>
> Please work with us for that, if everybody makes his own corner
> instrumentation, we are not going to make any progress in having a
> powerful and unified tracing/profiling.
>
> The first step is to pinpoint the important places that need
> tracepoints, and then just write a perf trace script to use the
> provided informations by these tracepoints.
> 
> I can help about that if needed.

Yeah, I agree that trace would be better way to do it.  This patch was
added because slow-work had similar facility and David was unhappy
about losing easy way to monitor if cmwq replaces slow-work.  I'll be
happy to drop this one.  David, what do you think?

Thanks.

-- 
tejun
