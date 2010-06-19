Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0FSUHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:07:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab0FSUHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:07:47 -0400
Date: Sat, 19 Jun 2010 13:07:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100619130730.36f8d567@infradead.org>
In-Reply-To: <20100619194937.GR18946@basil.fritz.box>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-10-git-send-email-tj@kernel.org>
	<20100616204854.4b036f87@infradead.org>
	<87zkyro1xl.fsf@basil.nowhere.org>
	<4C1C830B.5020806@kernel.org>
	<20100619090031.GE18946@basil.fritz.box>
	<20100619075451.48c13589@infradead.org>
	<20100619194937.GR18946@basil.fritz.box>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 21:49:37 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > Here we have the opportunity to get real good information.. we KNOW
> > now an interrupt is coming, and we can even estimate how long it'll
> > be...  Even for the first few after a long time, before a pattern
> > emerges.
> 
> Ok but I thought the driver would just fill in a single number 
> likely. Is that really that good information?

Tejun suggested tracking this per handler, I'm assuming that instead of
the driver passed number

> 
> Alternatively each driver would need to implement some dynamic
> estimation algorithm, but that would be just mostly equivalent
> to having it all in the idle governour?

that's the whole point... let the irq layer track this stuff, and
inform the governor. the governor does not know irqs are expected..
with tejun's change, the irq layer at least will.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
