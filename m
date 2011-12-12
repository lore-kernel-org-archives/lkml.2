Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1LLXis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:38:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:55470 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1LLXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:38:47 -0500
Date: Tue, 13 Dec 2011 00:38:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andres Salomon <dilinger@queued.net>
cc: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
In-Reply-To: <20111212123131.502be350@queued.net>
Message-ID: <alpine.LFD.2.02.1112130035550.3020@ionos>
References: <4EE620A5.7080402@LiPPERTEmbedded.de> <20111212123131.502be350@queued.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Andres Salomon wrote:

> On Mon, 12 Dec 2011 16:41:25 +0100
> Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
> 
> > But I did not fail to notice that _none_ of the code in
> > drivers/clocksource/ uses IRQF_SHARED, obviously this must be
> > deliberate.
> 
> Hm, maybe tglx knows?  For my part, I don't think it would be a
> problem, but I can imagine the reason for not sharing being clock drift
> or something to that effect.

No, you can share a timer irq. The other drivers don't have the SHARED
flag set because they are on exclusive irq lines, which is the sane
thing to do. shared irqs suck and you figure that out once you try to
use that shared timer irq on a preempt-rt enabled kernel.

Thanks,

	tglx

