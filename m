Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1EaKdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:33:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:36542 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab1EaKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:33:00 -0400
Date: Tue, 31 May 2011 12:32:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] irq: catch more wrong return values from interrupt
 handlers
In-Reply-To: <1306824972-27067-3-git-send-email-sebastian@breakpoint.cc>
Message-ID: <alpine.LFD.2.02.1105311231150.3078@ionos>
References: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc> <1306824972-27067-3-git-send-email-sebastian@breakpoint.cc>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Sebastian Andrzej Siewior wrote:

> We now also accept return value IRQ_WAKE_THREAD from a threaded
> interrupt or IRQ_HANDLED | IRQ_WAKE_THREAD from primary and theaded
> handler which is wrong. We need to accept the later on shared handlers
> where one handler is primary only and the second is a threaded handler.
> This patch attempts to catch them. Unfortunately this patch introduces
> two new types so I'm not sure if it is worth it.

I'd rather avoid that ugliness. If driver writers are that stupid,
there is probably more significant wreckage than this.

Thanks,

	tglx
