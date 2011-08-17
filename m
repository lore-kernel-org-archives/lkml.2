Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1HQUMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:12:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab1HQUMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110817163520.334269161@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org>
	<20110817163520.334269161@codeaurora.org>
Date: Wed, 17 Aug 2011 22:12:20 +0200
Message-ID: <CACM3HyE=vHtr7Y-9k7PWvxmGt+O1bJyxs18CEmtzMdq9zOtfqw@mail.gmail.com>
Subject: Re: [patch 05/36] Hexagon: Add syscalls
From: Jonas Bonn <jonas.bonn@gmail.com>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +#define __ARCH_WANT_SYSCALL_DEPRECATED
> +
> +#ifndef __GLIBC__
> +/* It seems these are all needed for uClibc...
> + * However, if glibc is compiled w/ these turned on, then it will
> + * will fail (typically with 32/64-bit compat problems). */
> +#define __ARCH_WANT_SYSCALL_OFF_T
> +#define __ARCH_WANT_SYSCALL_NO_AT
> +#define __ARCH_WANT_SYSCALL_NO_FLAGS
> +#endif
> +

These are no longer appropriate for the mainline kernel.  These
definitions are mainly intended to be used during a transitional
period until the necessary changes can be made in the required C
library.

The recommendation is to just carry these defines as an external patch
while the necessary changes are made in uClibc.  I've just about got
the necessary changes done and will send them to the uClibc mailing
list shortly, so hopefully the need for these defines will go away
really soon now.


> +asmlinkage int sys_fork(void)
> +{
> +       struct pt_regs *pregs = current_thread_info()->regs;
> +
> +       return do_fork(SIGCHLD, pregs->SP, pregs, 0, NULL, NULL);
> +}
> +
> +asmlinkage int sys_vfork(void)
> +{
> +       struct pt_regs *pregs = current_thread_info()->regs;
> +
> +       return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD,
> +                      pregs->SP, pregs, 0, NULL, NULL);
> +}

These two are deprecated.

/Jonas
