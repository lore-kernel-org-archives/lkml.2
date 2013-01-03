Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3ACXIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:08:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3ACXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:08:17 -0500
Date: Thu, 3 Jan 2013 15:08:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 13/32] wait: Add wait_event_hrtimeout()
Message-Id: <20130103150816.f0dda169.akpm@linux-foundation.org>
In-Reply-To: <1356573611-18590-15-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-15-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012 17:59:51 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> Analagous to wait_event_timeout() and friends, this adds
> wait_event_hrtimeout() and wait_event_interruptible_hrtimeout().
> 
> Note that unlike the versions that use regular timers, these don't
> return the amount of time remaining when they return - instead, they
> return 0 or -ETIME if they timed out.

Why is this?

> +/**
> + * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + * @timeout: timeout, in jiffies
> + *
> + * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
> + * @condition evaluates to true or a signal is received.
> + * The @condition is checked each time the waitqueue @wq is woken up.
> + *
> + * wake_up() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + *
> + * The function returns 0 if @condition became true, or -ETIME if the timeout
> + * elapsed.
> + */

this, methinks:

--- a/include/linux/wait.h~wait-add-wait_event_hrtimeout-fix
+++ a/include/linux/wait.h
@@ -370,7 +370,7 @@ do {									\
  * wait_event_hrtimeout - sleep until a condition gets true or a timeout elapses
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @timeout: timeout, in jiffies
+ * @timeout: timeout, as a ktime_t
  *
  * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
  * @condition evaluates to true or a signal is received.
@@ -395,7 +395,7 @@ do {									\
  * wait_event_interruptible_hrtimeout - sleep until a condition gets true or a timeout elapses
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @timeout: timeout, in jiffies
+ * @timeout: timeout, as a ktime_t
  *
  * The process is put to sleep (TASK_INTERRUPTIBLE) until the
  * @condition evaluates to true or a signal is received.
_

