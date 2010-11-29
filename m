Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0K2THq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:07:46 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:21586
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab0K2THo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:07:44 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz936eK1432N98dNa3c1kzz1202hzz8275dhz2dh2a8h691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Date: Mon, 29 Nov 2010 13:07:20 -0600
From: Scott Wood <scottwood@freescale.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <sodaville@linutronix.de>, <devicetree-discuss@lists.ozlabs.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
In-Reply-To: <1290984809.32570.208.camel@pasglop>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	<1290808645.32570.158.camel@pasglop>
	<20101128160449.GC30784@www.tglx.de>
	<1290984809.32570.208.camel@pasglop>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2010 19:08:40.0670 (UTC) FILETIME=[D57EA7E0:01CB8FF8]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 09:53:29 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Sun, 2010-11-28 at 17:04 +0100, Sebastian Andrzej Siewior wrote:
> > >> +	isa@legacy {

What is "@legacy"?  I don't think I've seen that in a unit address
before, googling only turns up this device tree, and a quick grep
through the ISA and base OF specs turns up nothing.

> > >> +		device_type = "isa";
> > >> +		compatible = "simple-bus";
> > >
> > >What does "simple-bus" means ?
> > I added simple bus in order to get probed. But I now I rember that this
> > is also supported per device_type. I get rid of it.
> 
> device_type is a nasty bugger, we are trying to get rid of Linux
> reliance on it.
> 
> Things like "simple-bus" don't rock my boat either, it's adding to the
> device-tree "informations" that are specific to the way Linux will
> interpret it, which is not how it should be.

The motivation for simple-bus comes from Linux, but its definition is
OS-neutral.  It indicates that no special bus knowledge is required to
access the devices under it.

I don't think it applies to ISA, though -- I/O space is special bus
knowledge, and the "ranges" looks weird for memory-space as well.

If we're going to get rid of device_type here, it would be nice to have
some other way to indicate that this node follows the ISA binding,
without having to recognize an implementation-specific compatible.

-Scott

