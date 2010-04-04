Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0DDKrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:47:23 -0400
Received: from isilmar.linta.de ([213.133.102.198]:44395 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378Ab0DDKrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:47:16 -0400
Date: Sun, 4 Apr 2010 12:47:08 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100404104708.GA5922@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <20100403235326.GA23445@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403235326.GA23445@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Apr 03, 2010 at 04:53:26PM -0700, Dmitry Torokhov wrote:
> On Sun, Apr 04, 2010 at 12:33:28AM +0200, Dominik Brodowski wrote:
> > 
> > 4) SynPS/2 touchpad: 
> > Why does moving the touchpad lead to sooo many IRQs? I can't look as fast
> > as the mouse pointer seems to get new data:
> >   62,5% (473,1)       <interrupt> : PS/2 keyboard/mouse/touchpad 
> > 
> 
> 80 pps @ 6 bytes/packet = 480 interrupts/sec.
> 
> You can try using psmouse.rate=40 to limit it to 40 pps which should
> bring it to the rate of standard PS/2 mouse at the expense of
> sensitivity...

as a sidenote: if we know -- like here -- that the next IRQ will be issued
soon, in approximately 1.75 ms (well, at least on my system), might it make
sense to make tick_nohz_get_sleep_length() smarter to know about this?

Best,
	Dominik
