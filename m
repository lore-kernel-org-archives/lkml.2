Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2EDNDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:03:46 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:13423
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162Ab2EDNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:03:44 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz9371I1432N98dK4015Izz1202hzz8275bh8275dhz2dh668h839h93fhd25h)
X-WSS-ID: 0M3I1LZ-01-H1J-02
X-M-MSG: 
Date: Fri, 4 May 2012 15:03:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/2][RESEND] x86/pci/amd: Restore
 early_fill_mp_bus_to_node
Message-ID: <20120504130332.GC12199@alberich.amd.com>
References: <20120427143410.GB27535@alberich.amd.com>
 <20120427143621.GC27535@alberich.amd.com>
 <CAErSpo7gkkqZgR0TZ5Xx162pLN9ZaYVhMmyHn+H8Lqr1CBSXXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAErSpo7gkkqZgR0TZ5Xx162pLN9ZaYVhMmyHn+H8Lqr1CBSXXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:33:17AM -0600, Bjorn Helgaas wrote:
> On Fri, Apr 27, 2012 at 8:36 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> >
> > Once upon a time this function was overloaded with quirky stuff to fix
> > resource detection on systems w/ _CRS defects (seems that some Sun and
> > HP systems were affected).
> >
> > See commit 30a18d6c3f1e774de656ebd8ff219d53e2ba4029
> > (x86: multi pci root bus with different io resource range, on 64-bit)
> >
> > Restore the old function and thus decouple it from the quirk that is
> > CPU family specific (e.g. it won't work on AMD family 15h CPUs). BTW,
> > I assume that the _CRS stuff is working on current systems.
> >
> > This is required to properly initilize the numa_node information of
> > existing PCI busses and associated devices.
> 
> I applied some of Yinghai's patches that also touch this area.  Can
> you refresh these so they apply on top of my "next" branch
> (git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next)?

Arrgh, will adapt my patch and resend it (asap).

> Can you also be more specific about what these patches fix?

> My understanding is that amd_bus.c (1) sets NUMA info with
> set_mp_bus_to_node() and (2) figures out MMIO and I/O port apertures,
> which are only used when blind probing and when ignoring _CRS.
> 
> It seems like the main change in this patch is that we skip (2)
> completely when family >= 0x11, and I don't understand what that could
> fix.
> 

The patch restores a very old function that was used to detect the
nearest node for a PCI bus, so yes it's used to do (1). IMHO this
function was totally screwed up with Yinghai's code to do (2). It
seems that Sun has (had?) some systems where (2) was req'd. I don't
care about this part. But I'd like to do (1) on all AMD CPU NUMA
systems.

> [more comments below]

Will consider them when reworking the patch.


Thanks,
Andreas


