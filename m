Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0EVMMR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 08:12:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48804 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0EVMMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 08:12:13 -0400
Date: Sat, 22 May 2010 06:12:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-pci@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
	(firewire-ohci)
Message-ID: <20100522121212.GQ10452@parisc-linux.org>
References: <4BF7B147.9020502@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF7B147.9020502@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 12:26:15PM +0200, Stefan Richter wrote:
> Hi,
> 
> I came across a report of the subject message.  What does it mean; what
> type of bug should be look for?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=587178
> >>>
> firewire_ohci 0000:04:00.4: PCI INT C -> GSI 16 (level, low) -> IRQ 16
> firewire_ohci 0000:04:00.4: setting latency timer to 64
> firewire_ohci: Added fw-ohci device 0000:04:00.4, OHCI version 1.0
> DRHD: handling fault status reg 2
> DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> DMAR:[fault reason 02] Present bit in context entry is clear
> DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> DMAR:[fault reason 02] Present bit in context entry is clear
> DMAR:[DMA Read] Request device [04:00.0] fault addr fffff000
> DMAR:[fault reason 02] Present bit in context entry is clear
> <<<
> 
> The log sounds as if this happens during from-device DMA of 04:00.4 into
> a consistent buffer, yet the fault is logged for device 04:00.0.  The
> log is from a Dell M4500.  The devices are, according to a web search,
> 04:00.0 CardBus bridge [0607]: Ricoh Co Ltd Device [1180:e476] (rev 02)
> 04:00.4 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd Device [1180:e832]
> (rev 03) (prog-if 10)

I would guess that the DMAR can't distinguish between the different
devices behind the Cardbus bridge.  Adding Dave Woodhouse.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
