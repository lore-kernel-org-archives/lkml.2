Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0E1OGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:06:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46283 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0E1OGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:06:00 -0400
Date: Fri, 28 May 2010 15:05:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528140537.GE25798@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org> <20100527230806.4deb6de3@lxorguk.ukuu.org.uk> <20100527220949.GB10602@srcf.ucam.org> <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com> <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk> <AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com> <20100528121636.34be17ad@lxorguk.ukuu.org.uk> <AANLkTinVs-YfxCHm7Zees9oq_NYySqI6UFtX57JlsLy-@mail.gmail.com> <20100528145526.0ce83c85@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528145526.0ce83c85@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 02:55:26PM +0100, Alan Cox wrote:

> The following cannot occur on my laptop for simple idling
> 
> 	Alarm
> 		Suspend
> 
> because the Alarm resets the suspend timer when it is delivered.

Userspace is about to write to /sys/power/state when it gets scheduled. 
Alarm delivery occurs at that instant. Kernel has no idea that it's 
about to go to sleep, so the driver handles things appropriately and 
clears the hardware state. Userspace gets scheduled, writes and the 
system suspends. The problem is that having userspace decidie to 
initiate a suspend and then actually initiate a suspend isn't an atomic 
operation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
