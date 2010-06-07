Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0FGAB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 20:01:59 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43174 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752296Ab0FGAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 20:01:58 -0400
Date: Sun, 6 Jun 2010 20:01:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Vitaly Wool <vitalywool@gmail.com>, Neil Brown <neilb@suse.de>,
       <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <20100606152946.GA11351@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1006061956510.4894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, Matthew Garrett wrote:

> The difference between idle-based suspend and opportunistic suspend is 
> that the former will continue to wake up for timers and will never be 
> entered if something is using CPU, whereas the latter will be entered 
> whenever no suspend blocks are held. The problem with opportunistic 
> suspend is that you might make the decision to suspend simultaneusly 
> with a wakeup event being received. Suspend blocks facilitate 
> synchronisation between the kernel and userspace to ensure that all such 
> events have been consumed and handld appropriately.

Remember that suspend takes place in several phases, the first of which 
is to freeze tasks.  The phases can be controlled individually by the 
process carrying out a suspend, and there's nothing to prevent you from 
stopping after the freezer phase.  Devices won't get powered down, but 
Android uses aggressive runtime power management for its devices 
anyway.

If you do this then the synchronization can be carried out entirely
from userspace, with no need for kernel modifications such as suspend
blockers. And since Android can reach essentially the same low-power
state from idle as from suspend, it appears that they really don't need
any kernel changes at all.

Alan Stern

