Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab1I3OG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1I3OG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:06:26 -0400
Date: Fri, 30 Sep 2011 16:02:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <jweiner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: proc: hold cred_guard_mutex in check_mem_permission()
Message-ID: <20110930140246.GA15556@redhat.com>
References: <20110928202020.GA3164@redhat.com> <20110929071314.GA7734@wicker.gateway.2wire.net> <20110929114827.GA9279@redhat.com> <20110930010518.GB9594@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930010518.GB9594@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Stephen Wilson wrote:
>
> On Thu, Sep 29, 2011 at 01:48:27PM +0200, Oleg Nesterov wrote:
>
> > So I think we should simply remove ->cred_guard_mutex.
>
> Yes, I think that is right,

Great,

> together with removing the
> ptrace_may_access() check

Agreed, but this needs a separate patch.

Plus rcu_read_lock + ptrace_parent() should die, we simply need

	task->ptrace && task->parent == current

And task_is_stopped_or_traced() should be task_is_traced(), starting
from 3.0 TASK_STOPPED && ptrace is not possible.

I'll send the patches tomorrow.

Thanks,

Oleg.

