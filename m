Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1DVM1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:27:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51602 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977Ab1DVM07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:26:59 -0400
Date: Fri, 22 Apr 2011 13:26:57 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/7] signal: retarget_shared_pending: optimize
 while_each_thread() loop
Message-ID: <20110422132657.646f1774@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134518.GD15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134518.GD15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:45:18 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> retarget_shared_pending() blindly does recalc_sigpending_and_wake() for
> every sub-thread, this is suboptimal. We can check t->blocked and stop
> looping once every bit in shared_pending has the new target.
> 
> Note: we do not take task_is_stopped_or_traced(t) into account, we are
> not trying to speed up the signal delivery or to avoid the unnecessary
> (but harmless) signal_wake_up(0) in this unlikely case.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice.

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

