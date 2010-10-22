Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0JVJPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:15:22 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:53111 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753367Ab0JVJPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:15:20 -0400
Message-ID: <20101022091519.1924.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
To: benh@kernel.crashing.org (Benjamin Herrenschmidt)
Date: Fri, 22 Oct 2010 04:15:19 -0500 (GMT+5)
Cc: segher@kernel.crashing.org (Segher Boessenkool),
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287608215.2198.23.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
> 
> On Wed, 2010-10-20 at 13:33 -0500, pacman@kosh.dhis.org wrote:
> > > Just try :-) "quiesce" is something that afaik only apple ever
> > > implemented anyways. It uses hooks inside their OF to shut down all
> > > drivers that do bus master (among other HW sanitization tasks).
> > 
> > I booted a version with a prom_close_stdout after the last prom_debug. It
> > didn't have any effect. That 1000Hz clock was still ticking. 
> 
> Ok so you'll have to make up a "workaround" in prom_init that looks for
> OHCI's in the device-tree and disable them.

I'm a long way from understanding how to do that.

> 
> Check if the OHCI node has some existing f-code words you can use for
> that with "dev /path-to-ohci words" in OF for example. If not, you may

Nothing there but open close decode-unit encode-unit

> need to use the low level register accessors. Use OF client interface
> "interpret" to run forth code from C.

Here are the major problems:

1. How do I locate all usb nodes in the device tree?

2. How do I know if a particular usb node is OHCI?

3. Knowing that a node is OHCI, how do I know where its control registers
are? I'm sure this is calculated from the "reg" property but I don't see how.

4. Knowing where the control registers are, how do I access them? Do I need
to request a virt-to-phys mapping or can I assume that it's already mapped,
or that the "rl!" command will do the right thing with a physical address?

5. Which control register should I use to tell the OHCI to be quiet? Just do
a general reset, or is there something that specifically turns off the
counter that's been causing the trouble?

-- 
Alan Curry
