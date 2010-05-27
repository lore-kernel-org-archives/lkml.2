Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017Ab0E0S3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:29:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42855 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486Ab0E0S3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:29:30 -0400
Date: Thu, 27 May 2010 19:29:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527182913.GO3543@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins> <20100527181433.GG3543@srcf.ucam.org> <1274984291.27810.5802.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274984291.27810.5802.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:18:11PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 19:14 +0100, Matthew Garrett wrote:
> > If I get a WoL 
> > packet in the 0.5 of a second between userspace deciding to suspend and 
> > actually doing so, the system shouldn't suspend. 
> 
> Please re-read Thomas' description of how a driver should do the state
> transition.
>
> So either we get the packet before suspend, and we cancel the suspend,
> or we get it after and we wake up. What's the problem, and how does that
> need suspend blockers?

In order to cancel the suspend we need to keep track of whether 
userspace has consumed the event and reacted appropriately. Since we 
can't do this with the process scheduler, we end up with something that 
looks like suspend blockers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
