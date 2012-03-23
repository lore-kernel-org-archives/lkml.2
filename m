Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2CWJJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:09:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:44256 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2CWJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:08:59 -0400
Date: Fri, 23 Mar 2012 10:08:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build error with !SMP && !GENERIC_HARDIRQS
In-Reply-To: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
Message-ID: <alpine.LFD.2.02.1203231003210.2542@ionos>
References: <1332487384-13803-1-git-send-email-shc_work@mail.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012, Alexander Shiyan wrote:

> When compile kernel with !SMP && !GENERIC_HARDIRQS we are have
> following error:
>   CC      kernel/irq/manage.o
> kernel/irq/manage.c:41: error: expected identifier or '(' before 'asm'
> 
> This error appears because header contain other definition for
> synchronize_irq in include/linux/hardirq.h.
> extern void synchronize_irq(unsigned int irq);
> 
> This patch fix this problem.

Errm, which problem ?

kernel/irq/* is not compiled at all when CONFIG_GENERIC_HARDIRQS=n.

So nothing to fix here.

Thanks,

	tglx
