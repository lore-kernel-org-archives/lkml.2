Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1A0Eo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 23:44:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50739
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab1A0Eo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 23:44:28 -0500
Date: Wed, 26 Jan 2011 20:45:02 -0800 (PST)
Message-Id: <20110126.204502.104053498.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, dhowells@redhat.com,
        x86@kernel.org, benh@kernel.crashing.org, rth@twiddle.net,
        tony.luck@intel.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
        chris@zankel.net
Subject: Re: [patch 4/6] rwsem: Move duplicate init macros and functions to
 linux/rwsem.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110126195833.771812729@linutronix.de>
References: <20110126195810.247325792@linutronix.de>
	<20110126195833.771812729@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 26 Jan 2011 20:06:00 -0000

> The rwsem initializers and related macros and functions are mostly the
> same. Some of them lack the lockdep initializer, but having it in
> place does not matter for architectures which do not support lockdep.
> 
> powerpc, sparc, x86: No functional change
> 
> sh, s390: Removes the duplicate init_rwsem (inline and #define)
> 
> alpha, ia64, xtensa: Use the lockdep capable init function in
>        	     	     lib/rwsem.c which is just uninlining the init
>        	     	     function for the LOCKDEP=n case
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
