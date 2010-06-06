Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0FFQkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0FFQkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:40:19 -0400
Date: Sun, 6 Jun 2010 18:38:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Evan Teran <eteran@alum.rit.edu>,
       Jan Kratochvil <jan.kratochvil@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace: x86: stepping in a signal handler leaks
	X86_EFLAGS_TF
Message-ID: <20100606163848.GA19800@redhat.com>
References: <20100602192318.GA26735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602192318.GA26735@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Oleg Nesterov wrote:
>
> I am starting to think we should fix this per arch. As for x86, perhaps
> we should start with this one-liner
>
> 		spin_unlock_irq(&current->sighand->siglock);
>
> 		tracehook_signal_handler(sig, info, ka, regs,
> 	-				 test_thread_flag(TIF_SINGLESTEP));
> 	+				 test_and_clear_thread_flag(TIF_SINGLESTEP));
>
> 		return 0;
> 	 }
>
> then do other changes.

I am sending this patch. It is still not clear to me what is the
"right" fix, we need more discussion. Let's fix the bug first.

Oleg.

