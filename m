Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2JBE6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:58:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51215 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JBE6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:58:47 -0400
Date: Tue, 2 Oct 2012 06:58:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 -tip 2/5] x86, MSI: Allocate as many multiple IRQs as
 requested
Message-ID: <20121002045842.GC7756@gmail.com>
References: <cover.1349074231.git.agordeev@redhat.com>
 <c588272d963c0f73957cc4b104291f8b19e7454f.1349074231.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c588272d963c0f73957cc4b104291f8b19e7454f.1349074231.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> When multiple MSIs are enabled with pci_enable_msi_block() the number of
> allocated IRQs 'nvec' is rounded up to the nearest value of power of two.
> That could lead to a condition when number of requested and used IRQs is
> less than number of actually allocated IRQs.
> 
> This fix introduces 'msi_desc::nvec' field to address the above issue -
> when non-zero, it holds the number of allocated IRQs. Otherwise, the old
> method is used.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |   16 +++++++---------
>  drivers/pci/msi.c              |   10 ++++++++--
>  include/linux/msi.h            |    1 +
>  3 files changed, 16 insertions(+), 11 deletions(-)

This should be switched with the first patch: first extend the 
generic MSI code, then add x86 support for that variant.

Adding multi-MSI support in one patch then tweaking it in the 
very next patch makes little sense and cannot possibly have been 
tested much so it's a potential bisection trap.

Thanks,

	Ingo
