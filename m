Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1DLMQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:16:09 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39419 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab1DLMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:16:05 -0400
Date: Tue, 12 Apr 2011 13:15:43 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: signal: handle_signal() should use
 sigprocmask()
Message-ID: <20110412131543.231659d2@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110411172201.GF32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
	<20110411172201.GF32469@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 19:22:01 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> This is ugly, but if sigprocmask() needs retarget_shared_pending() then
> handle signal should follow this logic. In theory it is newer correct to
							   ^^^ never

> add the new signals to current->blocked, the signal handler can sleep/etc
> so we should notify other threads in case we block the pending signal and
> nobody else has TIF_SIGPENDING.
> 
> Of course, this change doesn't make signals faster :/
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

I guess all assigments to current->blocked need auditing now? Forcing
everything through sigprocmask() seems worthwhile to me.

-- 
Matt Fleming, Intel Open Source Technology Center
