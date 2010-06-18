Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0FRG1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:27:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0FRG1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:27:20 -0400
Date: Thu, 17 Jun 2010 23:26:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
Message-ID: <20100617232649.6db5cc55@infradead.org>
In-Reply-To: <4C1A5197.8060409@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-10-git-send-email-tj@kernel.org>
	<20100616204854.4b036f87@infradead.org>
	<4C19DA64.8000409@kernel.org>
	<alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>
	<4C1A05AF.5010405@kernel.org>
	<20100617124343.5889067c@lxorguk.ukuu.org.uk>
	<4C1A4548.3020602@kernel.org>
	<20100617090229.543af62c@infradead.org>
	<4C1A5197.8060409@kernel.org>
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

On Thu, 17 Jun 2010 18:47:19 +0200
Tejun Heo <tj@kernel.org> wrote:

> 
> Hmmm... the thing is that there will be many cases which won't fit
> irq_expect() model (why irq_watch() exists in the first place) and for
> the time being libata is the only one providing that data.  Would the
> data still be useful to determine which c-state to use?

yes absolutely. One of the hard cases right now that the C state code
has is that it needs to predict the future. While it has a ton of
heuristics, including some is there IO oustanding" ones, libata is a
really good case: libata will know generally that within one seek time
(5 msec on rotating rust, much less on floating electrons) there'll be
an interrupt (give or take, but this is what we can do heuristics for
on a per irq level).
So it's a good suggestion of what the future will be like, MUCH better
than any hint we have right now... all we have right now is some
history, and when the next timer is.... 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
