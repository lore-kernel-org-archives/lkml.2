Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1DLMSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:18:01 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:35358 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483Ab1DLMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:18:00 -0400
Date: Tue, 12 Apr 2011 13:17:57 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] x86: signal: sys_rt_sigreturn() should use
 sigprocmask()
Message-ID: <20110412131757.78e436d5@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411172229.GG32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
	<20110411172229.GG32469@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:22:29 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Normally sys_rt_sigreturn() restores the old current->blocked which was
> changed by handle_signal(), and unblocking is always fine.
> 
> But the debugger or application itself can change frame->uc_sigmask and
> thus we need sigprocmask()->retarget_shared_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

I'm just curious, have you actually seen this bug?
