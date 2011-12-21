Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1LULSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:43583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1LULSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:22 -0500
Message-Id: <20111221105739.798864333@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:39 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/7] improve printk reliability
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So these are my current efforts to make my own console output more
reliable. I've hit every deadlock described in this series and a few
more.

With these patches applied I can printk() and WARN() from inside 
scheduler context and not have my machine deadlock, even without the 
aid of early_printk().

While I'll go an remove the sole printk() I found in the scheduler
so that we don't have to rely on the console doing this, it is good
to have a reliable console that can do this.

As it stands some of the patches, the semaphore one in particular,
are really too ugly to live so I won't push those but wanted to share
anyway.

Debugging this was 'fun', and I really hope to not have to do it
again :-)

