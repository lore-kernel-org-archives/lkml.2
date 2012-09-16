Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2IPOgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 10:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2IPOgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 10:36:38 -0400
Date: Sun, 16 Sep 2012 16:38:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes: Kill UTASK_BP_HIT state
Message-ID: <20120916143822.GA20312@redhat.com>
References: <20120914171513.GA29599@redhat.com> <20120914171600.GA29649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171600.GA29649@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14, Oleg Nesterov wrote:
>
> Kill UTASK_BP_HIT state, it buys nothing but complicates the code.
> It is only used in uprobe_notify_resume() to decide who should be
> called, we can check utask->active_uprobe != NULL instead. And this
> allows us to simplify handle_swbp(), no need to clear utask->state.

I am starting to think this patch makes even more sense than I thought.

> Likewise we could kill UTASK_SSTEP,

In fact we can kill utask->state. But I just realized we can also kill
uprobe_deny_signal() and simplify arch_uprobe_xol_was_trapped() logic.

But this needs some (simple) changes in arch/ code, so we need to wait
until powerpc is merged.

Oleg.

