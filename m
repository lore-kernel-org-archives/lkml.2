Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab0E0Ruu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:50:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46673 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab0E0Rut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:50:49 -0400
Date: Thu, 27 May 2010 18:50:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527175030.GA3543@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <20100527184918.3d090921@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527184918.3d090921@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 06:49:18PM +0100, Alan Cox wrote:
> > ACPI provides no guarantees about what level of hardware functionality 
> > remains during S3. You don't have any useful ability to determine which 
> > events will generate wakeups. And from a purely practical point of view, 
> > since the latency is in the range of seconds, you'll never have a low 
> > enough wakeup rate to hit it.
> 
> So PCs with current ACPI don't get opportunistic suspend capability. It
> probably won't be supported on the Commodore Amiga either - your point ?

Actually, the reverse - there's no terribly good way to make PCs work 
with scheduler-based suspend, but there's no reason why they wouldn't 
work with the current opportunistic suspend implementation.

> > Suspend blockers are the mechanism for the 
> > driver to indicate whether the wakeup event has been handled. That's 
> > what they're there for. The in-kernel ones don't paper over anything.
> 
> Semantically the in kernel blockers and the in kernel expression of
> device driven constraints are the same thing except that instead of 
> yes/no you replace the boolean with information.

In some cases, not all. It may be a latency constraint (in which case 
pm_qos is an appropriate mechanism), but instead it may be something 
like "A key was pressed but never read" or "A network packet was 
received but not delivered". These don't fit into the pm_qos model, but 
it's state that you have to track.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
