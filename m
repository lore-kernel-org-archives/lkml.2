Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1LLWMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:12:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57937 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754281Ab1LLWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:12:16 -0500
Date: Mon, 12 Dec 2011 17:12:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: USB list <linux-usb@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Busy-waiting with interrupts disabled
Message-ID: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How long is it okay to busy-wait with interrupts disabled?  Are there 
any clear-cut guidelines?

My feeling is that for ordinary desktop use, 1-2 ms should be about the
limit, but other people may feel differently.  (There's one spot in
ehci-hcd where the delay can last up to 250 ms, which does seem rather
excessive.  Fortunately it never takes that long unless the hardware is
broken.)

No doubt the RT people would say the upper bound should be on the order
of a few microseconds or less.  I'd be happy to change ehci-hcd, which
has several delays in the 1-2 ms range -- but they tend to be nested
inside routines that are called within the scope of spinlock_irq, which
means a fair amount of rewriting would be needed.

Any thoughts or recommendations?

Alan Stern

