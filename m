Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0EVTJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:09:13 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:54293 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757975Ab0EVTJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:09:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UpWt1jpB68gRkbAXcxUM1ZTncKfbkchB4RswYeXcNQ5hkzjAT7WFLQf5bVtD1qmIkksdGSSUmnt6JsuMnu3Yn0PygrfdI/IIuEsWxbGtoRkqk96KZnu93c9VZ97UhYhi;
Date: Sat, 22 May 2010 12:09:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-pci@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
 (firewire-ohci)
Message-ID: <20100522120905.154ff932@jbarnes-x201>
In-Reply-To: <1274553643.11551.17300.camel@macbook.infradead.org>
References: <4BF7B147.9020502@s5r6.in-berlin.de>
	<20100522121212.GQ10452@parisc-linux.org>
	<1274553643.11551.17300.camel@macbook.infradead.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 19:40:43 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Sat, 2010-05-22 at 06:12 -0600, Matthew Wilcox wrote:
> > On Sat, May 22, 2010 at 12:26:15PM +0200, Stefan Richter wrote:
> > > Hi,
> > > 
> > > I came across a report of the subject message.  What does it mean; what
> > > type of bug should be look for?
> > > 
> > > https://bugzilla.redhat.com/show_bug.cgi?id=587178
> > > >>>
> > > firewire_ohci 0000:04:00.4: PCI INT C -> GSI 16 (level, low) -> IRQ 16
> > > firewire_ohci 0000:04:00.4: setting latency timer to 64
> > > firewire_ohci: Added fw-ohci device 0000:04:00.4, OHCI version 1.0
> > > DRHD: handling fault status reg 2
> > > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > > DMAR:[fault reason 02] Present bit in context entry is clear
> > > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > > DMAR:[fault reason 02] Present bit in context entry is clear
> > > DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> > > DMAR:[fault reason 02] Present bit in context entry is clear
> > > <<<
> > > 
> > > The log sounds as if this happens during from-device DMA of 04:00.4 into
> > > a consistent buffer, yet the fault is logged for device 04:00.0.  The
> > > log is from a Dell M4500.  The devices are, according to a web search,
> > > 04:00.0 CardBus bridge [0607]: Ricoh Co Ltd Device [1180:e476] (rev 02)
> > > 04:00.4 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd Device [1180:e832]
> > > (rev 03) (prog-if 10)
> > 
> > I would guess that the DMAR can't distinguish between the different
> > devices behind the Cardbus bridge.  Adding Dave Woodhouse.
> 
> Yeah, the DMAR looks at the source-id in the PCIe transactions, and it
> sounds like those are all 04:00.0. But we've probably set up the DMAR to
> allow the transactions from 04:00.4, and then it naturally faults when a
> "different" device actually ends up doing the transaction.
> 
> If you make the pci_find_upstream_pcie_bridge() function do the
> appropriate thing for this device, does it then work as expected?
> 
> Whether that's a _sane_ thing to do or not is possibly more of a Jesse
> question...

Well, if cardbus bridges tend to behave this way in general it would
make sense to simply use the cardbus bride id everywhere, rather than
the specific functions of the device.  Cc'ing Dominik.

Jesse
