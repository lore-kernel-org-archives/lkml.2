Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2JFIsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:48:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53697 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab2JFIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:48:30 -0400
Date: Sat, 6 Oct 2012 14:18:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: Do not delete uprobe if
 uprobe_unregister() fails
Message-ID: <20121006084858.GA9145@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194204.GA11326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194204.GA11326@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100608-5806-0000-0000-00001A55AABE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:04]:

> delete_uprobe() must not be called if register_for_each_vma(false)
> fails to remove all breakpoints, __uprobe_unregister() is correct.
> The problem is that register_for_each_vma(false) always returns 0
> and thus this logic does not work.
> 
> 1. Change verify_opcode() to return 0 rather than -EINVAL when
>    unregister detects the !is_swbp insn, we can treat this case
>    as success and currently unregister paths ignore the error
>    code anyway.
> 
> 2. Change remove_breakpoint() to propagate the error code from
>    write_opcode().
> 
> 3. Change register_for_each_vma(is_register => false) to remove
>    as much breakpoints as possible but return non-zero if
>    remove_breakpoint() fails at least once.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

