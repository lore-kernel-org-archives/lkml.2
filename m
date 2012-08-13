Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2HMNVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:21:51 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35688 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2HMNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:21:50 -0400
Date: Mon, 13 Aug 2012 18:51:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: change uprobe_mmap() to ignore the errors
 but check fatal_signal_pending()
Message-ID: <20120813132108.GH31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173742.GA13262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173742.GA13262@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081313-5564-0000-0000-000003FFA1CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:42]:

> Once install_breakpoint() fails uprobe_mmap() "ignores" all other
> uprobes and returns the error.
> 
> It was never really needed to to stop after the first error, and
> in fact it was always wrong at least in -ENOTSUPP case.
> 
> Change uprobe_mmap() to ignore the errors and always return 0.
> This is not what we want in the long term, but until we teach
> the callers to handle the failure it would be better to remove
> the pointless complications. And this doesn't look too bad, the
> only "reasonable" error is ENOMEM but in this case the caller
> should be oom-killed in the likely case or the system has more
> serious problems.
> 
> However it makes sense to stop if fatal_signal_pending() == T.
> In particular this helps if the task was oom-killed.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

