Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0D2AIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0D2AIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:08:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoffer Dall <christofferdall@christofferdall.dk>
X-Fcc: ~/Mail/linus
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [C/R ARM v2][PATCH 1/3] ARM: Rudimentary syscall interfaces
In-Reply-To: Christoffer Dall's message of  Monday, 26 April 2010 17:43:41 -0400 <1272318223-28438-2-git-send-email-christofferdall@christofferdall.dk>
References: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
	<1272318223-28438-2-git-send-email-christofferdall@christofferdall.dk>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100429000808.CFFBD7154@magilla.sf.frob.com>
Date: Wed, 28 Apr 2010 17:08:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * syscalls.h - Linux syscall interfaces for ARM

s/syscalls/syscall/

> +static inline int get_swi_instruction(struct task_struct *task,
> +				      struct pt_regs *regs,
> +				      unsigned long *instr)
> +{

Why doesn't this just use access_process_vm?

> +/*
> + * This function essentially duplicates the logic from vector_swi in
> + * arch/arm/kernel/entry-common.S. However, that code is in the
> + * critical path for system calls and is hard to factor out without
> + * compromising performance. 
> + */

No clue about the ARM details, not reviewing that.  I think this is too big
to be an inline and should be in some arch/arm/kernel/*.c place instead.
Of course, if (config_aeabi && !config_oabi) is true at compile time, it's
not large at all.  So perhaps just move the compelx cases to a function
and leave the "Pure EABI" fork in the inline.


Thanks,
Roland
