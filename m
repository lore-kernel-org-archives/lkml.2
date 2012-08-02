Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2HBE6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 00:58:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55100 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab2HBE6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 00:58:42 -0400
Date: Thu, 2 Aug 2012 10:28:31 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 2/2] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120802045831.GA8538@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120801134337.GA3923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801134337.GA3923@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080204-3534-0000-0000-00000B08BDE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 03:43:37PM +0200, Oleg Nesterov wrote:

...

> However, I am not sure we can trust it. We are in kernel mode,
> DEBUGCTLMSR_BTF can be cleared by kprobes (Ananth, please correct me).
> I think we need to check TIF_BLOCKSTEP.

Kprobes resets DEBUGCTLMSR_BTF only if we have to single-step in
hardware. It puts the flag back if TIF_BLOCKSTEP is set, after the
single-step is complete; so yes, a better check is TIF_BLOCKSTEP.

Ananth

