Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2JFHUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:20:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41024 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2JFHUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:20:06 -0400
Date: Sat, 6 Oct 2012 12:50:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes/x86: Only rep+nop can be emulated correctly
Message-ID: <20121006072033.GG27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194158.GA11316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194158.GA11316@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100607-5806-0000-0000-00001A555D80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:41:58]:

> __skip_sstep() correctly detects the "nontrivial" nop insns,
> but since it doesn't update regs->ip we can not really skip
> "0x0f 0x1f | 0x0f 0x19 | 0x87 0xc0", the probed application
> is killed by SIGILL'ed handle_swbp().
> 
> Remove these additional checks. If we want to implement this
> correctly we need to know the full insn length to update ->ip.
> 
> rep* + nop is fine even without updating ->ip.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

