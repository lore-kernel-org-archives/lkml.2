Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2J2Fdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:33:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41985 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2J2Fds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:33:48 -0400
Date: Mon, 29 Oct 2012 11:03:40 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes/powerpc: Do not use arch_uprobe_*_step()
	helpers
Message-ID: <20121029053340.GB3400@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121028173900.GA14621@redhat.com> <20121028173928.GA14649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028173928.GA14649@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102905-5806-0000-0000-00001B22B9C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 06:39:28PM +0100, Oleg Nesterov wrote:
> No functional changes.
> 
> powerpc is the only user of arch_uprobe_enable/disable_step() helpers,
> but they should die. They can not be used correctly, every arch needs
> its own implementation (like x86 does). And they do not really help
> even as initial-and-almost-working code, arch_uprobe_*_xol() hooks can
> easily use user_enable/disable_single_step() directly.
> 
> Change arch_uprobe_*_step() to do nothing, and convert powerpc to use
> ptrace helpers. This is equally wrong, powerpc needs the arch-specific
> fixes.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

I will send a powerpc patch to directly use the MSR bits for stepping.

Ananth

