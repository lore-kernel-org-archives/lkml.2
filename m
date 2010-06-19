Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0FSOzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:55:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:46171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0FSOzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:55:15 -0400
Date: Sat, 19 Jun 2010 07:54:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100619075451.48c13589@infradead.org>
In-Reply-To: <20100619090031.GE18946@basil.fritz.box>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-10-git-send-email-tj@kernel.org>
	<20100616204854.4b036f87@infradead.org>
	<87zkyro1xl.fsf@basil.nowhere.org>
	<4C1C830B.5020806@kernel.org>
	<20100619090031.GE18946@basil.fritz.box>
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

On Sat, 19 Jun 2010 11:00:31 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > IIUC, it's not to help or optimize polling itself.  It just gives
> > us a way to estimate when the next interrupt would be so that power
> > can be optimized for non polling cases.
> 
> Shouldn't the idle governour estimate this already?

we have a set of heuristics in the idle governor to try to predict the
future. For patterns that are regular in some shape of form we can do
this.

Here we have the opportunity to get real good information.. we KNOW
now an interrupt is coming, and we can even estimate how long it'll
be...  Even for the first few after a long time, before a pattern
emerges.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
