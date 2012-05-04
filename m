Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2EDN0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:26:00 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:48952
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab2EDNZ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:25:58 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz9371Ic89bh154dM1432N98dKzz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3I2N4-01-INQ-02
X-M-MSG: 
Date: Fri, 4 May 2012 15:25:49 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2][RESEND] x86/pci/amd: Enable
 early_fill_mp_bus_to_node on AMD family 15h models 0-0xf
Message-ID: <20120504132549.GD12199@alberich.amd.com>
References: <20120427143410.GB27535@alberich.amd.com>
 <20120427143745.GD27535@alberich.amd.com>
 <CAErSpo584dcpGhmp-jcP_Zsznmz9ZkfPuxpF3UK9UVfcnFUdRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAErSpo584dcpGhmp-jcP_Zsznmz9ZkfPuxpF3UK9UVfcnFUdRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:34:15AM -0600, Bjorn Helgaas wrote:
> On Fri, Apr 27, 2012 at 8:37 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> >
> > While at it avoid calling this function on family 11h (aka Griffin)
> > which was a mobile part and doesn't support NUMA.
> 
> This changelog doesn't seem like it goes with this patch.  It looks
> more related to the first patch (though that affects family 11h and
> greater, not just family 11h).

So maybe I should repeat the contents of the subject line in the
changelog.

The first patch restores the function to set the NUMA node info for
busses. Linux behaviour shouldn't change after the first patch at all.

This (the second) patch will enable node detection for AMD CPU family
15h model 00-0fh (with 0x1600 as device id for NB function 0). (see
subject line) In addition it removes the NB id for CPU family 11h from
this code.  That CPU was used only in Laptops (single socket). A
mapping of bus to node is not required there. And also figuring out
MMIO and I/O port apertures while ignoring _CRS shouldn't be a use
case for such systems.

I think Device ID 0x1300 was added with commit
35ddd068fb94b187e94a3fc497ccecf27bdda9ae (x86: use bus conf in NB conf
fun1 to get bus range on, on 64-bit)

But unfortunately the changelog of this patch doesn't mention why this
is strictly req'd.


HTH,

Andreas

> >  arch/x86/pci/amd_bus.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> > index 0384e69..d552b29 100644
> > --- a/arch/x86/pci/amd_bus.c
> > +++ b/arch/x86/pci/amd_bus.c
> > @@ -27,7 +27,7 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
> >        { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
> >        { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
> >        { 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
> > -       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
> > +       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 },
> >  };
> >
> >  /**
> > --
> > 1.7.8.5
> >
> >
> >
> 


