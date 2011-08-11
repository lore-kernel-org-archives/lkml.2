Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1HKTNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:13:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:38424 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1HKTNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:13:31 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Date: Thu, 11 Aug 2011 21:13:08 +0200
In-Reply-To: <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313089988.8491.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:02 -0700, Alex Neronskiy wrote:

> +static unsigned long softstall_trace_entries[STALL_MAX_TRACE_DEPTH * 2];
> +static struct stack_trace softstall_traces[2];
> +static spinlock_t softstall_locks[2];
> +static DEFINE_SPINLOCK(softstall_read_lock);
> +static DEFINE_SPINLOCK(softstall_write_lock);
> +static int soft_read_ind;
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
>  static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
> @@ -46,7 +67,12 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
>  static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
>  
>  unsigned long worst_hardstall;
> +static unsigned long hardstall_trace_entries[STALL_MAX_TRACE_DEPTH * 2];
> +static struct stack_trace hardstall_traces[2];
> +static spinlock_t hardstall_locks[2];
> +static DEFINE_SPINLOCK(hardstall_read_lock);
> +static DEFINE_SPINLOCK(hardstall_write_lock);
> +static int hard_read_ind; 

You really gotta love typing, but the rest of us know to use structures
for this.
