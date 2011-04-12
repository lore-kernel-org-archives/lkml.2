Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1DLLk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:40:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44344 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab1DLLkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:40:24 -0400
Date: Tue, 12 Apr 2011 12:40:22 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] signal: retarget_shared_pending: consider
 shared/unblocked signals only
Message-ID: <20110412124022.6256b8ed@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411172045.GC32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
	<20110411172045.GC32469@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:20:45 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> exit_signals() checks signal_pending() before
> retarget_shared_pending() but this is suboptimal. We can avoid the
> while_each_thread() loop in case when there are no shared signals
> visible to us.
> 
> Add the has_pending_signals(shared_pending, blocked) check. We don
> not use tsk->blocked directly but pass this sigset_t as an argument,
> this is needed for the next patch.
> 
> Note: we can optimize this more. while_each_thread(t) can check
> t->blocked into account and stop after every pending signal has the
> new target.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice. Do you have plans to implement that further optimisation?

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
