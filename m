Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1LLWru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:47:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab1LLWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:47:44 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pH78MhJE8zsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=C9o07-ltnvv7o_bANBAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323730061.1377.13.camel@gandalf.stny.rr.com>
Subject: Re: Busy-waiting with interrupts disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 17:47:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 17:12 -0500, Alan Stern wrote:
> How long is it okay to busy-wait with interrupts disabled?  Are there 
> any clear-cut guidelines?
> 
> My feeling is that for ordinary desktop use, 1-2 ms should be about the
> limit, but other people may feel differently.  (There's one spot in
> ehci-hcd where the delay can last up to 250 ms, which does seem rather

"250 ms", holy freaking OUCH! Batman!


> excessive.  Fortunately it never takes that long unless the hardware is
> broken.)
> 
> No doubt the RT people would say the upper bound should be on the order
> of a few microseconds or less.  I'd be happy to change ehci-hcd, which
> has several delays in the 1-2 ms range -- but they tend to be nested
> inside routines that are called within the scope of spinlock_irq, which
> means a fair amount of rewriting would be needed.
> 
> Any thoughts or recommendations?

Note that in -rt, spinlocks are really mutexes (unless they are
raw_spinlocks, which you shouldn't do). Thus, if your spin is with
spinlock_irq, it wont affect -rt, as it will not have interrupts
disabled.

But I could imagine that such a long latency could manifest itself into
something nasty (lots of interrupts queued up and such) that normal
desktop users might see a hiccup or two.

-- Steve


