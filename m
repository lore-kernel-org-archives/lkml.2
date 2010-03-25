Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab0CYL5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:57:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CYL5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:57:04 -0400
Date: Thu, 25 Mar 2010 12:57:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325115700.GM20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325105033.35bceffd@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325105033.35bceffd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pretty much the only 'core' driver today which enables IRQs in the irq
> handlers and needs it is the old IDE layer. There are also a couple of

Thanks. 

I'm tempted to just ignore it in this case, but in theory it might
still have troubles if there are a lot of interrupts to the same CPU.

I've only had a report on a very large system with a very high interrupt
rate on a very fast NIC though, so presumably it's not too common.

Anyways this patch will fix the problem for all drivers that do 
not explicitely enable interrupts, which is the overwhelming majority.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
