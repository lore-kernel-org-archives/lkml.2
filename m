Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2L3PrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 10:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2L3PrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 10:47:22 -0500
Date: Sun, 30 Dec 2012 16:46:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] uprobes: Change handle_swbp() to expose bp_vaddr to
	handler_chain()
Message-ID: <20121230154657.GA28488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Inspired by the recent uretrpobe RFC's. I think it simply makes no sense
to call handler/skip/arch_uprobe_pre_xol with regs->ip pointing to the
"random" address after the task hits bp.

Ananth, could you please confirm 2/2 can't break powerpc? It "obviously"
shouldn't because uprobe_get_swbp_addr() is a "nop" on ppc, but still
your ack is welcomed.

Oleg.

