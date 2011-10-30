Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab1J3O5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 10:57:17 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:44863
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab1J3O5Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 10:57:16 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1447M1432N98dKzz1202hzz15d4R8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LTVW79-01-D4Q-02
X-M-MSG: 
Date: Sun, 30 Oct 2011 15:57:07 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] PCI: Add implementation for PRI capability
Message-ID: <20111030145706.GH32555@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
 <1317131836-11822-4-git-send-email-joerg.roedel@amd.com>
 <CAMuHMdUJU+4n73P6Kc920+ZeJZouCc52QVa1Emanjiiu1kmq-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUJU+4n73P6Kc920+ZeJZouCc52QVa1Emanjiiu1kmq-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 03:36:13PM -0400, Geert Uytterhoeven wrote:
> On Tue, Sep 27, 2011 at 15:57, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Implement the necessary functions to handle PRI capabilities
> > on PCIe devices. With PRI devices behind an IOMMU can signal
> > page fault conditions to software and recover from such
> > faults.
> >
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  drivers/pci/Kconfig      |    9 +++
> >  drivers/pci/ats.c        |  167 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/pci-ats.h  |   42 ++++++++++++
> >  include/linux/pci_regs.h |   12 +++
> >  4 files changed, 230 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > index 1d8ce83..fb1e9707 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -85,6 +85,15 @@ config PCI_IOV
> >
> >          If unsure, say N.
> >
> > +config PCI_PRI
> > +       bool "PCI PRI support"
> 
> Shouldn't this depend on PCI?
> 
> It doesn't seem to hurt on PCI-less platforms, but I prefer not seeing
> PCI-related questions when CONFIG_PCI is not set.

You are right, I send a fix soon. Thanks for the report.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

