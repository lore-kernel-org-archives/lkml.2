Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2IWUTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab2IWUSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:04 -0400
Date: Sun, 23 Sep 2012 22:19:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes: remove is_swbp_at_addr() from
	register/unregister
Message-ID: <20120923201921.GA27424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

1. the usage of is_swbp_at_addr() is confusing. This series tries
   to answer the questions we got during the discussion about
   powerpc port which has multiple trap insns.

   Ananth, please review too ;) at least the changelog in 1/4.

   Note: the changelog doesn't mention is_swbp_insn(). If powerpc
   wants to change it, we need 2 helpers for verify_opcode() and
   for is_swbp_at_addr().

2. This is also preparation for the pre-filtering I am working on.

   In particular, this series tries to make clear the fact that
   register/unregister should be "idempotent".

Oleg.

 kernel/events/uprobes.c |  165 +++++++++++++++++------------------------------
 1 files changed, 59 insertions(+), 106 deletions(-)

