Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2IDJCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:02:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52203 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2IDJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:02:08 -0400
Date: Tue, 4 Sep 2012 10:01:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
	arm-current tree
Message-ID: <20120904090132.GG24085@n2100.arm.linux.org.uk>
References: <20120904160626.f1dcb67ebbb145053c49da8c@canb.auug.org.au> <201209040808.25103.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209040808.25103.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 08:08:24AM +0000, Arnd Bergmann wrote:
> On Tuesday 04 September 2012, Stephen Rothwell wrote:
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mm/mmu.c between commit a849088aa155 ("ARM: Fix ioremap() of
> > address zero") from the arm-current tree and commit c2794437091a ("ARM:
> > Add fixed PCI i/o mapping") from the arm-soc tree.
> > 
> > I am not sure how to fix this, so I have used the arm-current version of
> > the change to pmd_empty_section_gap() since that changed the vm->flags.
> > It may be that just changing the vm->flags value in vm_reserve_area_early()
> > would be ok?
> 
> If I read this correctly, we want pci_reserve_io to use VM_ARM_STATIC_MAPPING
> while pmd_empty_section_gap should use VM_ARM_EMPTY_MAPPING, so we probably
> want to add a flag argument to the vm_reserve_area_early() function.

Whereas Rob said to me that both can use VM_ARM_EMPTY_MAPPING when I
queried this conflict last week.
