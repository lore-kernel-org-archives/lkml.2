Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2I0EDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:03:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46077 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:03:40 -0400
Date: Thu, 27 Sep 2012 06:03:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -tip 0/5] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <20120927040335.GA1957@gmail.com>
References: <cover.1346653435.git.agordeev@redhat.com>
 <20120926123824.GB7123@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926123824.GB7123@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> On Mon, Sep 03, 2012 at 11:16:55AM +0200, Alexander Gordeev wrote:
> >   5/5:	based on Jeff's comments:
> > 
> > 	- AHCI specific code moved from libata-core.c to libahci.c;
> > 
> > 	- the host-wide lock concern addressed - ahci_interrupt() handler
> > 	  split in two parts: ahci_hw_interrupt() hardware context handler
> > 	  and ahci_thread_fn() threaded handler;
> > 
> > 	- host->lock statistics attached;
> 
> Hi Jeff,
> 
> Would you please comment on the changes and numbers?

Yep, given the diffstat:

 Documentation/PCI/MSI-HOWTO.txt |   37 ++++++-
 arch/x86/kernel/apic/io_apic.c  |  170 +++++++++++++++++++++++++++++--
 drivers/ata/ahci.c              |   14 ++-
 drivers/ata/ahci.h              |    5 +
 drivers/ata/libahci.c           |  211 +++++++++++++++++++++++++++++++++++++-
 drivers/pci/msi.c               |   36 ++++++-
 include/linux/irq.h             |    6 +
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 ++++--
 kernel/irq/irqdesc.c            |   31 ++++++
 11 files changed, 509 insertions(+), 39 deletions(-)

We absolutely need a very happy and enthusiastic Acked-by from 
Jeff before we can pursue it :-)

Thaks,

	Ingo
