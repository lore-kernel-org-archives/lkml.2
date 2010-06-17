Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab0FQLQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:16:41 -0400
Received: from www.tglx.de ([62.245.132.106]:33129 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0FQLQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:16:39 -0400
Date: Thu, 17 Jun 2010 13:12:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, bphilips@suse.de,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
In-Reply-To: <4C19DA64.8000409@kernel.org>
Message-ID: <alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-10-git-send-email-tj@kernel.org> <20100616204854.4b036f87@infradead.org> <4C19DA64.8000409@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jun 2010, Tejun Heo wrote:

> Hello, Arjan.
> 
> On 06/17/2010 05:48 AM, Arjan van de Ven wrote:
> > On Sun, 13 Jun 2010 17:31:35 +0200
> > Tejun Heo <tj@kernel.org> wrote:
> >> + */
> >> +void expect_irq(struct irq_expect *exp)
> > 
> > I would like to suggest an (optional) argument to this with a duration
> > within which to expect an interrupt....
> > 
> > that way in the backend we can plumb this also into the idle handler
> > for C state selection...
> 
> Hmmm.... oh, I see.  Wouldn't it be much better to use moving avg of
> IRQ durations instead of letting the driver specify it?  Drivers are
> most likely to just hard code it and It's never gonna be accurate.

Right, but that's probably more accurate than the core code heuristics
ever will be.

Thanks,

	tglx
