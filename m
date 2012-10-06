Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2JFHRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:17:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46537 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2JFHRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:17:40 -0400
Date: Sat, 6 Oct 2012 12:48:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes: Kill set_orig_insn()->is_swbp_at_addr()
Message-ID: <20121006071808.GF27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120923201921.GA27424@redhat.com>
 <20120923201950.GA27456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120923201950.GA27456@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100607-7282-0000-0000-00000DA8E750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-23 22:19:50]:

> Unlike set_swbp(), set_orig_insn()->is_swbp_at_addr() makes sense,
> although it can't prevent all confusions.
> 
> But the usage of is_swbp_at_addr() is equally confusing, and it adds
> the extra get_user_pages() we can avoid.
> 
> This patch removes set_orig_insn()->is_swbp_at_addr() but changes
> write_opcode() to do the necessary checks before replace_page().
> 
> Perhaps it also makes sense to ensure PAGE_MAPPING_ANON in unregister
> case.
> 
> find_active_uprobe() becomes the only user of is_swbp_at_addr(),
> we can change its semantics.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---



Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

