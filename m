Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1KITYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:24:37 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36741 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752826Ab1KITYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:24:35 -0500
Message-ID: <4EBAD329.1020309@xenotime.net>
Date: Wed, 09 Nov 2011 11:23:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for Nov 9 (build errors summary)
References: <20111109135826.7f8270fb7151cf7939998942@canb.auug.org.au>
In-Reply-To: <20111109135826.7f8270fb7151cf7939998942@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 06:58 PM, Stephen Rothwell wrote:
> Hi all,


1.  on i386, when CONFIG_SMP is not enabled:

arch/x86/built-in.o: In function `hpet_setup_msi_irq':
hpet.c:(.text+0x12114): undefined reference to `arch_setup_hpet_msi'
hpet.c:(.text+0x12123): undefined reference to `destroy_irq'
arch/x86/built-in.o: In function `hpet_msi_capability_lookup':
hpet.c:(.text+0x121fb): undefined reference to `create_irq_nr'
arch/x86/built-in.o:(.data+0x314): undefined reference to `native_setup_msi_irqs'
arch/x86/built-in.o:(.data+0x318): undefined reference to `native_teardown_msi_irq'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x6307a): undefined reference to `create_irq'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x630a3): undefined reference to `arch_setup_dmar_msi'
drivers/built-in.o: In function `dmar_set_interrupt':
(.text+0x630c0): undefined reference to `destroy_irq'
drivers/built-in.o: In function `free_dmar_iommu':
(.text+0x65e19): undefined reference to `destroy_irq'

2.  When ATA_SFF is enabled but ATA_BMDMA is not enabled:

drivers/ata/libata-sff.c: In function 'ata_pci_init_one':
drivers/ata/libata-sff.c:2538:3: error: implicit declaration of function 'ata_pci_bmdma_prepare_host'
drivers/ata/libata-sff.c:2549:40: error: 'ata_bmdma_interrupt' undeclared (first use in this function)

3.  on x86_64:

ERROR: "intel_iommu_gfx_mapped" [drivers/char/agp/intel-gtt.ko] undefined!

4.  when CONFIG_NET is not enabled:

drivers/staging/et131x/et131x.c:5489:12: error: 'et131x_pci_setup' undeclared here (not in a function)

patch should be in Greg's to-apply queue.



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
