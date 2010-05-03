Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0ECN12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:27:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:59044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302Ab0ECN1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:27:17 -0400
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpu_stop
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <1271952554-22368-4-git-send-email-tj@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 May 2010 15:26:32 +0200
Message-ID: <1272893192.5605.122.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
> @@ -2909,7 +2912,9 @@ redo:
>                         }
>                         raw_spin_unlock_irqrestore(&busiest->lock, flags);
>                         if (active_balance)
> -                               wake_up_process(busiest->migration_thread);
> +                               stop_one_cpu_nowait(cpu_of(busiest),
> +                                       active_load_balance_cpu_stop, busiest,
> +                                       &busiest->active_balance_work); 

So who guarantees busiest->active_balance_work isn't already enqueued by
some other cpu's load-balancer run?


