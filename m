Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab0E0Rbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:31:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36814 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0E0Rbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:31:32 -0400
Date: Thu, 27 May 2010 18:31:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527173118.GE2468@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:24:02PM +0200, Thomas Gleixner wrote:

> Oh no. They paper over a short coming. If there is a pending event,
> the kernel knows that. It just does not make use of this
> information. Blockers just paper over this by sprinkling
> do_not_suspend() calls all over the place. What a sensible solution.

Even if we could use suspend-via-deep-idle-state on PCs, we still need 
to be able to enter suspend while the system isn't idle. There's two 
ways to do that:

1) Force the system to be idle. Doing this race-free is difficult.

2) Enter suspend even though the system isn't idle. Since we can't rely 
on the scheduler, we need drivers to know whether userspace has consumed 
all wakeup events before allowing the transition to occur. Doing so 
requires either in-kernel suspend blockers or something that's almost 
identical.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
