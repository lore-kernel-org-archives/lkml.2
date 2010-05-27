Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab0E0SGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:06:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:57179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab0E0SGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:06:48 -0400
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
In-Reply-To: <20100527175920.GE3543@srcf.ucam.org>
References: <20100527171644.GA2468@srcf.ucam.org>
	 <1274980856.27810.5582.camel@twins> <20100527172510.GC2468@srcf.ucam.org>
	 <1274981288.27810.5609.camel@twins> <20100527173218.GF2468@srcf.ucam.org>
	 <1274981750.27810.5641.camel@twins> <20100527174140.GB3187@srcf.ucam.org>
	 <1274982397.27810.5679.camel@twins> <20100527175258.GB3543@srcf.ucam.org>
	 <1274982981.27810.5719.camel@twins>  <20100527175920.GE3543@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 20:06:38 +0200
Message-ID: <1274983598.27810.5761.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:59 +0100, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 07:56:21PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 18:52 +0100, Matthew Garrett wrote:
> > 
> > > If that's what you're aiming for then you don't need to block 
> > > applications on hardware access because they should all already have 
> > > idled themselves.
> > 
> > Correct, a well behaved app would have. I thought we all agreed that
> > well behaved apps weren't the problem?
> 
> Ok. So the existing badly-behaved application ignores your request and 
> then gets blocked. And now it no longer responds to wakeup events. 

It will, when it gets unblocked from whatever thing it got stuck on.

> So you penalise well-behaved applications without providing any benefits to 
> badly-behaved ones.

Uhm, how again is blocking a badly behaved app causing harm to the well
behaved one?

The well behaved one didn't get blocked and still happily waiting (on
its own accord, in sys_poll() or something) for something to happen, if
it would get an event it'd be placed on the runqueue and do its thing.
