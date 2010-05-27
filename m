Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab0E0UCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:02:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36649 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab0E0UCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:02:32 -0400
Date: Thu, 27 May 2010 21:02:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527200217.GA7449@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins> <20100527181433.GG3543@srcf.ucam.org> <20100527200313.5c532f2f@lxorguk.ukuu.org.uk> <20100527191302.GC5703@srcf.ucam.org> <20100527205009.391803b6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527205009.391803b6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:50:09PM +0100, Alan Cox wrote:

> So I guess if you are driving this rom user space (which I take it you
> are given you talk about housekeeping)
> 
> 	foreach app we need to suspend
> 		kick app to suspend (signal)
> 		(policy) kick harder if needed (SIGSTOP/bitch/shall I
> 					kill it dialogue)

This would need to be atomic, but in any case:

1) Policy decision is made
2) Wakeup event is received by task
3) Task gets stopped between receiving the event and handing it off to 
policy agent

At which point you suspend when you should have remained awake.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
