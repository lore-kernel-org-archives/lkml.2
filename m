Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0E0RVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:21:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0RVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:21:03 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527171644.GA2468@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	 <20100527155201.GA31937@srcf.ucam.org>
	 <20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
	 <20100527161943.GA32764@srcf.ucam.org>
	 <alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
	 <20100527170740.GA1980@srcf.ucam.org> <1274980391.27810.5552.camel@twins>
	 <20100527171644.GA2468@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:20:56 +0200
Message-ID: <1274980856.27810.5582.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:16 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:13:11PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 18:07 +0100, Matthew Garrett wrote:
> > > No. The useful property of opportunistic suspend is that nothing gets 
> > > scheduled. That's fundamentally different to a deep idle state.
> > 
> > I think Alan and Thomas but certainly I am saying is that you can get to
> > the same state without suspend.
> > 
> > Either you suspend (forcefully don't schedule stuff), or you end up
> > blocking all tasks on QoS/resource limits and end up with an idle system
> > that goes into a deep idle state (aka suspend).
> >
> > So why isn't blocking every task on a QoS/resource good enough for you?
> 
> Because you may then block them in such a way that they never handle an 
> event that should wake them.

*blink*, do explain?

Suppose X (or whatever windowing system) will block all clients that try
to draw when you switch off your screen.

How would we not wake them when we do turn the screen back on and start
servicing the pending requests again?

Pretty much the same for everything else, input events, WoL etc..


