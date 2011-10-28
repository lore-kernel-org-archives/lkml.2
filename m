Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1J1IoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:44:01 -0400
Received: from fieldses.org ([174.143.236.118]:45352 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1J1IoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:44:00 -0400
Date: Fri, 28 Oct 2011 04:43:51 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: document wait_for_completion_* return values
Message-ID: <20111028084351.GB2010@fieldses.org>
References: <20111006192246.GB28026@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006192246.GB28026@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 03:22:46PM -0400, bfields wrote:
> From: J. Bruce Fields <bfields@redhat.com>
> 
> The return-value convention for these functions varies depending on
> whether they're interruptible or can timeout.  It can be a little
> confusing--document it.

Ping?  Should I resend this or send it someplace different?

--b.

> 
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> ---
>  kernel/sched.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ccacdbd..ee84344 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4690,6 +4690,9 @@ EXPORT_SYMBOL(wait_for_completion);
>   * This waits for either a completion of a specific task to be signaled or for a
>   * specified timeout to expire. The timeout is in jiffies. It is not
>   * interruptible.
> + *
> + * The return value is 0 if timed out, and positive (at least 1, or number of
> + * jiffies left till timeout) if completed.
>   */
>  unsigned long __sched
>  wait_for_completion_timeout(struct completion *x, unsigned long timeout)
> @@ -4704,6 +4707,8 @@ EXPORT_SYMBOL(wait_for_completion_timeout);
>   *
>   * This waits for completion of a specific task to be signaled. It is
>   * interruptible.
> + *
> + * The return value is -ERESTARTSYS if interrupted, 0 if completed.
>   */
>  int __sched wait_for_completion_interruptible(struct completion *x)
>  {
> @@ -4721,6 +4726,9 @@ EXPORT_SYMBOL(wait_for_completion_interruptible);
>   *
>   * This waits for either a completion of a specific task to be signaled or for a
>   * specified timeout to expire. It is interruptible. The timeout is in jiffies.
> + *
> + * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
> + * positive (at least 1, or number of jiffies left till timeout) if completed.
>   */
>  long __sched
>  wait_for_completion_interruptible_timeout(struct completion *x,
> @@ -4736,6 +4744,8 @@ EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
>   *
>   * This waits to be signaled for completion of a specific task. It can be
>   * interrupted by a kill signal.
> + *
> + * The return value is -ERESTARTSYS if interrupted, 0 if completed.
>   */
>  int __sched wait_for_completion_killable(struct completion *x)
>  {
> @@ -4754,6 +4764,9 @@ EXPORT_SYMBOL(wait_for_completion_killable);
>   * This waits for either a completion of a specific task to be
>   * signaled or for a specified timeout to expire. It can be
>   * interrupted by a kill signal. The timeout is in jiffies.
> + *
> + * The return value is -ERESTARTSYS if interrupted, 0 if timed out,
> + * positive (at least 1, or number of jiffies left till timeout) if completed.
>   */
>  long __sched
>  wait_for_completion_killable_timeout(struct completion *x,
> -- 
> 1.7.4.1
> 
