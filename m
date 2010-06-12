Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0FLFNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:13:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:35773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0FLFNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:13:12 -0400
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <19474.172.742782.972629@ipc1.ka-ro>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	 <201006111557.12249.jeremy.kerr@canonical.com>
	 <19473.61547.684572.647641@ipc1.ka-ro>
	 <201006111718.47426.jeremy.kerr@canonical.com>
	 <19474.172.742782.972629@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 15:12:53 +1000
Message-ID: <1276319573.1962.180.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 11:23 +0200, Lothar Waßmann wrote:
> Hi,
> 
> > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > makes it impossible to call those functions in interrupt context.
> > 
> > Do we do this at the moment? I know at least one implementation of clk_enable 
> > uses a mutex for locking.
> > 
> You are probably talking about the Freescale i.MX51 kernel, that won't
> even boot, if you enable CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_SPINLOCK,
> CONFIG_DEBUG_LOCKDEP and CONFIG_DEBUG_SPINLOCK_SLEEP.
> The mutex in the clock implementation is one of the reasons.

Regardless. Clocks generally take time to enable. I don't believe doing
clock enable/disable at hard irq context is a great idea.

If you really want to do something like that, you can always use either
threaded interrupts, or if you know your clock is off, mask & defer your
handling to a work queue yourself.

Unless we have enough case of very fast switching clocks that would
really benefit for that but from my experience, when a device can issue
interrupts, it should have its clocks on, unless it's some kind of
"wakeup" interrupt in which case it can safely be delayed.

Cheers,
Ben.

