Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1DVOOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 10:14:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56789 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764Ab1DVOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 10:14:20 -0400
Date: Fri, 22 Apr 2011 15:14:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] x86: signal: sys_rt_sigreturn() should use
 set_current_blocked()
Message-ID: <20110422151418.3639a131@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134641.GH15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134641.GH15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:46:41 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Normally sys_rt_sigreturn() restores the old current->blocked which was
> changed by handle_signal(), and unblocking is always fine.
> 
> But the debugger or application itself can change frame->uc_sigmask and
> thus we need set_current_blocked()->retarget_shared_pending().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

But does sys_sigreturn() also need this change?
