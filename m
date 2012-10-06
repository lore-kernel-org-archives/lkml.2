Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab2JFJx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:53:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58017 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2JFJx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:53:56 -0400
Date: Sat, 6 Oct 2012 15:24:16 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes: Fix the racy uprobe->flags manipulation
Message-ID: <20121006095416.GE9145@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194227.GA11350@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194227.GA11350@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100609-5406-0000-0000-000000DD8A2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:27]:

> Multiple threads can manipulate uprobe->flags, this is obviously
> unsafe. For example mmap can set UPROBE_COPY_INSN while register
> tries to set UPROBE_RUN_HANDLER, the latter can also race with
> can_skip_sstep() which clears UPROBE_SKIP_SSTEP.
> 
> Change this code to use bitops.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

