Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab0FQQC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:02:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:49130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab0FQQCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:02:54 -0400
Date: Thu, 17 Jun 2010 09:02:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100617090229.543af62c@infradead.org>
In-Reply-To: <4C1A4548.3020602@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-10-git-send-email-tj@kernel.org>
	<20100616204854.4b036f87@infradead.org>
	<4C19DA64.8000409@kernel.org>
	<alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>
	<4C1A05AF.5010405@kernel.org>
	<20100617124343.5889067c@lxorguk.ukuu.org.uk>
	<4C1A4548.3020602@kernel.org>
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

On Thu, 17 Jun 2010 17:54:48 +0200
Tejun Heo <tj@kernel.org> wrote:

> Crazy devices too but I think they would
> fall in a single tick any way. 

not sure what ticks have to do with anything but ok ;)

> At any rate, let's say I have those
> numbers, how would I feed it into c-state selection?

if we have this, we need to put a bit of glue in the backend that
tracks (per cpu I suppose) the shortest expected interrupt, which
the C state code then queries.
(and in that regard, it does not matter if shortest expected is
computed via heuristic on a per irq basis, or passed in).

mapping an irq to a cpu is not a 100% science (since interrupts can
move in theory), but just assuming that the irq will happen on the same
CPU it happened last time is more than good enough.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
