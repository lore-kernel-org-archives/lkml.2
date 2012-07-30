Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2G3LHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 07:07:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40283 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2G3LHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 07:07:05 -0400
Date: Mon, 30 Jul 2012 16:36:58 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
	did it
Message-ID: <20120730110658.GC11147@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073011-5930-0000-0000-00000A588993
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 05:20:43PM +0200, Sebastian Andrzej Siewior wrote:
> If someone is using single stepping over uprobe brackpoint then after
> we pass the uprobe single step, single stepping is disabled and the user
> who enebaled them in the first place does not know anything about this.
> 
> This patch avoids enabling / disabling the single step mode if it is
> already enabled.

This could happen any time 2 different entities call the
user_(en/dis)able_single_step() helpers on the same thread.

Wouldn't the right way to fix it be to teach these helpers
to honor what the TIF_SINGLESTEP flag setting was in the first place?
This way you'd get rid of the portability concerns too, since these
helpers are available on most architectures.

Ananth

