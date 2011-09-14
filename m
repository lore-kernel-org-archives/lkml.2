Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1INQEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:04:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:42192 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1INQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:04:20 -0400
Date: Wed, 14 Sep 2011 18:04:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tero Kristo <t-kristo@ti.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] irq: call also chip->irq_mask from irq_disable
In-Reply-To: <1315990675-22814-1-git-send-email-t-kristo@ti.com>
Message-ID: <alpine.LFD.2.02.1109141757150.2723@ionos>
References: <1315990675-22814-1-git-send-email-t-kristo@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011, Tero Kristo wrote:

> Current implementation of the irq_disable only calls chip->irq_disable.
> This fails to disable interrupt on some chip implementations, as there
> are two alternative chip specific functions for this task,
> chip->irq_disable and chip->irq_mask. Added alternative path for
> chip->irq_disable also.

This does not fail to do so. It's done on purpose. We don't want to
access the interrupt chip when we can avoid it.

So we just mark the interrupt disabled and keep the line enabled.
When another interrupt happens, then the handling code checks the
disabled state of the line, masks the interrupt on the hardware level
and sets the pending bit. This is documented behaviour and not going
to change.

http://docs.blackfin.uclinux.org/kernel/generated/genericirq/ch04s03.html#Delayed_interrupt_disable

What are you trying to solve ?

Thanks,

	tglx
