Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1HWI7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:59:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45151 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183Ab1HWI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:58:49 -0400
Date: Tue, 23 Aug 2011 09:57:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, torvalds@linux-foundation.org,
        mporter@ti.com, Kevin Hilman <khilman@ti.com>,
        "Govindraj.R" <govindraj.raja@ti.com>
Subject: Re: [PATCH] tty: omap-serial: fix boot hang by converting to use a
 threaded IRQ handler (was Re: [PATCH] irq: always set IRQF_ONESHOT if no
 primary handler is specified)
Message-ID: <20110823095711.058d9cf4@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
	<C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
	<4E4D4A5F.202@linutronix.de>
	<20110818213418.GA20509@legolas.emea.dhcp.ti.com>
	<alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
	<alpine.DEB.2.00.1108222306300.28226@utopia.booyaka.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 23:10:21 -0600 (MDT)
Paul Walmsley <paul@pwsan.com> wrote:

> 
> Convert the omap-serial hardirq handler to a threaded IRQ handler. Without 
> this patch, OMAP boards which use the on-board OMAP UARTs and the 
> omap-serial driver will not boot to userspace after commit 
> f3637a5f2e2eb391ff5757bc83fb5de8f9726464 ("irq: Always set IRQF_ONESHOT if 
> no primary handler is specified").  Enabling CONFIG_DEBUG_SHIRQ reveals 
> 'IRQ handler type mismatch' errors:

There are multiple other drivers reporting all these problems - the
faulty irq change should be reverted at this point not the drivers
fiddled with.

Alan
