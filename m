Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934996Ab0E0S0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:26:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41882 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab0E0S0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:26:51 -0400
Date: Thu, 27 May 2010 19:26:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527182633.GN3543@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain> <20100527155201.GA31937@srcf.ucam.org> <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain> <20100527165931.GB1062@srcf.ucam.org> <alpine.LFD.2.00.1005271905000.3032@localhost.localdomain> <20100527172343.GB2468@srcf.ucam.org> <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271930350.3032@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:59:02PM +0200, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Matthew Garrett wrote:
> > ACPI provides no guarantees about what level of hardware functionality 
> > remains during S3. You don't have any useful ability to determine which 
> > events will generate wakeups. And from a purely practical point of view, 
> > since the latency is in the range of seconds, you'll never have a low 
> > enough wakeup rate to hit it.
> 
> Right, it does not as of today. So we cannot use that on x86
> hardware. Fine. That does not prevent us to implement it for
> architectures which can do it. And if x86 comes to the point where it
> can handle it as well we're going to use it. Where is the problem ? If
> x86 cannot guarantee the wakeup sources it's not going to be used for
> such devices. The kernel just does not provide the service for it, so
> what ?

We were talking about PCs. Suspend-as-c-state is already implemented for 
OMAP.

> So the only thing you are imposing to app writers is to use an
> interface which solves nothing and does not save you any power at
> all. 

It's already been demonstrated that the Android approach saves power.

> Runnable tasks and QoS guarantees are the indicators whether you can
> go to opportunistic suspend or not. Everything else is just window
> dressing.

As I keep saying, this is all much less interesting if you don't care 
about handling suboptimal applications. If you do care about them then 
the Android approach works. Nobody has demonstrated a scheduler-based 
one that does.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
