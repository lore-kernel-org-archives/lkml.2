Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0E0RYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:24:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36171 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754508Ab0E0RYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:24:06 -0400
Date: Thu, 27 May 2010 18:30:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527183041.0487bdf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527170740.GA1980@srcf.ucam.org>
References: <20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
	<20100527161943.GA32764@srcf.ucam.org>
	<alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
	<20100527170740.GA1980@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Opportunistic suspend is just a deep idle state, nothing else.
> 
> No. The useful property of opportunistic suspend is that nothing gets 
> scheduled. That's fundamentally different to a deep idle state.

Nothing gets scheduled in a deep idle state either - its idle. We leave
the idle state to schedule anything.

I believe the constraint is

- Do not auto-enter a state for which you cannot maintain the devices in
  use "properly".

On a current PC that generally means 'not suspend', on a lot of embedded
boards (including Android phones) it includes an opportunistic 'suspend'
and also several states half way between the PC deepest idles and suspend.

> > Stop thinking about suspend as a special mechanism. It's not - except
> > for s2disk, which is an entirely different beast.
> 
> On PCs, suspend has more in common with s2disk than it does C states.

Todays PCs are a special case. More to the point I don't think anyone is
expected opportunistic suspend to be useful on _todays_ x86 systems.

Even on todays PCs your assumption is questionable for virtual machines
where a VM suspend is a lot faster and rather useful.

Alan
