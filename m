Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672Ab0E0SOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:14:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41659 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab0E0SOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:14:45 -0400
Date: Thu, 27 May 2010 19:14:33 +0100
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
Message-ID: <20100527181433.GG3543@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274983333.27810.5744.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:02:13PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 18:57 +0100, Matthew Garrett wrote:
> > If you want to support forced suspend for laptops and you want to avoid 
> > the risk of losing wakeups then you need in-kernel suspend blockers. 
> > That's entirely orthogonal to Android's runtime power management.
> 
> The simple fact of life is, on PC style hardware suspend is mostly about
> missing events. I really _really_ want to miss mouse movement of my
> bluetooth mouse when the gear is stowed in my backpack.

That's fine - those shouldn't be configured as wakeup events.

> Its perfectly OK to miss events on _forced_ suspend.

No, it's not. Forced suspend may be in response to hitting a key, but it 
may also be in response to a 30 minute timeout expiring. If I get a WoL 
packet in the 0.5 of a second between userspace deciding to suspend and 
actually doing so, the system shouldn't suspend.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
