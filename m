Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1INTuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:50:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:42760 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab1INTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:50:22 -0400
Date: Wed, 14 Sep 2011 21:50:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tero Kristo <t-kristo@ti.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] irq: call also chip->irq_mask from irq_disable
In-Reply-To: <1316023293.2355.33.camel@sokoban>
Message-ID: <alpine.LFD.2.02.1109142149060.2723@ionos>
References: <1315990675-22814-1-git-send-email-t-kristo@ti.com> <alpine.LFD.2.02.1109141757150.2723@ionos> <1316023293.2355.33.camel@sokoban>
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
> On Wed, 2011-09-14 at 18:04 +0200, Thomas Gleixner wrote:
> > What are you trying to solve ?
> 
> I was seeing a hang with a chain handler implementation that was caused
> by this delayed disable implementation, I am using a generic chip with
> irq_mask / irq_unmask. Adding this patch to the kernel fixed the hang in
> this case. There might be something wrong in my implementation of the
> chain handler itself, I'll take a look at it again and try to figure out
> another way to avoid it. I have another idea I can pursue, and based on
> some initial testing it actually seems to be working.

chained handlers are not subject to disable/enable_irq usually. Care
to share the code ?

Thanks,

	tglx
