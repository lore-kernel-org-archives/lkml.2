Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2GaVQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:16:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:23616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2GaVQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:16:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191423372"
Subject: Re: [PATCH 0/3] x86, MSI: Support multiple MSIs in presense of IRQ
 remapping
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>
Date: Tue, 31 Jul 2012 14:12:49 -0700
In-Reply-To: <cover.1343732015.git.agordeev@redhat.com>
References: <cover.1343732015.git.agordeev@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343769169.2041.10.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 13:41 +0200, Alexander Gordeev wrote:
> Currently multiple MSI mode is limited to a single vector per device (at
> least on x86 and PPC). This series breathes life into pci_enable_msi_block()
> and makes it possible to set interrupt affinity for multiple IRQs, similarly
> to MSI-X. Yet, only for x86 and only when IOMMUs are present.
> 
> Although IRQ and PCI subsystems are modified, the current behaviour left
> intact. The drivers could just start using multiple MSIs just by following
> the existing documentation.

So while I am ok with the proposed changes, I will hold off acking until
I see the corresponding driver changes (using pci_enable_msi_block()
etc) that take advantage of these changes ;)

Did you have a specific device in mind and are the driver changes
coming?

thanks,
suresh

> 
> The patches are adapted to Ingo's -tip repository, x86/apic branch.
> 
> Alexander Gordeev (3):
>   x86, MSI: Support multiple MSIs in presense of IRQ remapping
>   x86, MSI: Allocate as many multiple IRQs as requested
>   x86, MSI: Minor readability fixes
> 
>  arch/x86/kernel/apic/io_apic.c |  170 +++++++++++++++++++++++++++++++++++++---
>  drivers/pci/msi.c              |   10 ++-
>  include/linux/irq.h            |    6 ++
>  include/linux/msi.h            |    1 +
>  kernel/irq/chip.c              |   30 +++++--
>  kernel/irq/irqdesc.c           |   31 +++++++
>  6 files changed, 226 insertions(+), 22 deletions(-)
> 
> -- 
> 1.7.7.6
> 
> 


