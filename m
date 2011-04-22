Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1DVMWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:22:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55579 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab1DVMWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:22:41 -0400
Date: Fri, 22 Apr 2011 13:22:38 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
 shared/unblocked signals only
Message-ID: <20110422132238.4258cc8b@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134501.GC15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134501.GC15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:45:01 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> exit_signals() checks signal_pending() before retarget_shared_pending() but
> this is suboptimal. We can avoid the while_each_thread() loop in case when
> there are no shared signals visible to us.
> 
> Add the "shared_pending.signal & ~blocked" check. We don't use tsk->blocked
> directly but pass ~blocked as an argument, this is needed for the next patch.
> 
> Note: we can optimize this more. while_each_thread(t) can check t->blocked
> into account and stop after every pending signal has the new target, see the
> next patch.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
