Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab0FANvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:51:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49420 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0FANvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:51:22 -0400
Date: Tue, 1 Jun 2010 14:51:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100601135102.GA8098@srcf.ucam.org>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk> <20100527223605.GB11364@srcf.ucam.org> <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk> <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop> <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com> <1275120618.27810.12699.camel@twins> <1275149418.4503.128.camel@mulgrave.site> <alpine.LFD.2.00.1005312231120.2933@localhost.localdomain> <1275340869.2823.344.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275340869.2823.344.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 04:21:09PM -0500, James Bottomley wrote:

> You're the one mentioning x86, not me.  I already explained that some
> MSM hardware (the G1 for example) has lower power consumption in S3
> (which I'm using as an ACPI shorthand for suspend to ram) than any
> suspend from idle C state.  The fact that current x86 hardware has the
> same problem may be true, but it's not entirely relevant.

As long as you can set a wakeup timer, an S state is just a C state with 
side effects. The significant one is that entering an S state stops the 
process scheduler and any in-kernel timers. I don't think Google care at 
all about whether suspend is entered through an explicit transition or 
something hooked into cpuidle - the relevant issue is that they want to 
be able to express a set of constraints that lets them control whether 
or not the scheduler keeps on scheduling, and which doesn't let them 
lose wakeup events in the process.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
