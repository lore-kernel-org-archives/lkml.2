Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1AUWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:24:56 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49880 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1AUWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:24:53 -0500
Date: Fri, 21 Jan 2011 23:24:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: sparclinux <sparclinux@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 0/5] sparc64: drop deprecated irq features
Message-ID: <20110121222451.GA29468@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches update sparc64 so no deprecated genirq
features are used.

I did this mainly to understand the genirq stuff better.
Originally I looked into sparc64 code and was confused
because it used deprecated stuff. So the logical step
was to update sparc64 to avoid the deprecated stuff.
So I did so and the result follows.

This is an RFC because:
- This is not yet tested
- I expect a (trivial) conflict when we get Thomas'
  __DO_irq stuff merged
- I expect to get some feedback that needs to be addressed

I made one conceptual change.
irq_handler_data was previously assinged to irq_data.chip_data.
This is changed so it uses irq_data.handler_data

Looking into kernel/irq/* this looked OK.

I plan to do some testing within the next week.

I looked at integrating struct virt_irq_table[] as
chip_data in irq_data.
But the way the virt_irq_alloc() function is used did not
make this bovious how to do so. So I played safe and did
not try to do so.

Any comments aprreciated.
If there are more features from genirq we could use let me
know and I may look at it.
And if something just looks wrong please say so too.

	Sam


Sam Ravnborg (5):
      sparc64: fix direct access to irq_desc
      sparc: in handler_irq() rename irq parameter to pil
      sparc64: all pointers to irq_handler_data renamed to handler_data
      sparc64: use {get,set}_irq_data for handler_data
      sparc64: use up-to-data genirq functions

 arch/sparc/Kconfig            |    2 -
 arch/sparc/kernel/irq_32.c    |   20 ++--
 arch/sparc/kernel/irq_64.c    |  197 ++++++++++++++++++++---------------------
 arch/sparc/kernel/sun4d_irq.c |   18 ++--
 4 files changed, 117 insertions(+), 120 deletions(-)
