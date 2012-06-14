Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2FNKeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:34:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:55529 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2FNKeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:34:14 -0400
Date: Thu, 14 Jun 2012 12:34:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] genirq: Resend nested irq's ancestor irq
In-Reply-To: <1339662697-4600-2-git-send-email-ning.n.jiang@gmail.com>
Message-ID: <alpine.LFD.2.02.1206141221360.3086@ionos>
References: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com> <1339662697-4600-2-git-send-email-ning.n.jiang@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Ning Jiang wrote:
> We'll set IRQS_PENDING for handle_nested_irq if it's disabled. When
> it's re-enabled later on, check_irq_resend() will detect this flag
> and trigger the software resend mechanism. resend_irqs() will call
> desc->handle_irq() directly to process this interrupt, hence the
> irq_nested_primary_handler() will be called for the nested irq which
> gives us a warning.
> 
> If we need to resend a nested interrupt, we have to trace all the
> way back to its ancestor and trigger ancestor's irq flow handler.

And what makes you believe that the ancestors demux handler will find
the irq bit of the nested interrupt still pending? There is NO
guarantee for that.

The correct solution for this is to replace the tasklet with a kernel
thread and check whether the interrupt is marked nested or not and
then invoke the correct function.

That requires a check for irq in progress in the nested handler as
well, but that's trivial to add.

Thanks,

	tglx
