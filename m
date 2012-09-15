Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab2IOHkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 03:40:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60644 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab2IOHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 03:40:07 -0400
Date: Sat, 15 Sep 2012 13:09:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uprobes: Fix UPROBE_SKIP_SSTEP checks in
	handle_swbp()
Message-ID: <20120915073957.GD7588@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120914171513.GA29599@redhat.com> <20120914171557.GA29642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171557.GA29642@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 12091507-9360-0000-0000-00000AAC553F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 07:15:57PM +0200, Oleg Nesterov wrote:
> If handle_swbp()->add_utask() fails but UPROBE_SKIP_SSTEP is set,
> cleanup_ret: path do not restart the insn, this is wrong. Remove
> this check and add the additional label for can_skip_sstep() = T
> case.
> 
> Note also that UPROBE_SKIP_SSTEP can be false positive, we simply
> can not trust it unless arch_uprobe_skip_sstep() was already called.
> 
> Also, move another UPROBE_SKIP_SSTEP check before can_skip_sstep()
> into this helper, this looks more clean and understandable.
> 
> Note: probably we should rename "skip" to "emulate" and I think
> that "clear UPROBE_SKIP_SSTEP" should be moved to arch_can_skip.

Agree. emulate is more accurate in this situation since, especially on
powerpc, we do emulate most instructions.

Ananth

