Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0ENSiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:38:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43264 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab0ENSiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:38:05 -0400
Message-ID: <4BED986D.1010403@zytor.com>
Date: Fri, 14 May 2010 11:37:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Petr Vandrovec <petr@vandrovec.name>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.34-rcX] Do not expect PCI devices to return zeroes
 in PCIe space
References: <20100501025423.GA10671@vana.vc.cvut.cz>
In-Reply-To: <20100501025423.GA10671@vana.vc.cvut.cz>
Content-Type: multipart/mixed;
 boundary="------------090802020705080501050707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090802020705080501050707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/30/2010 07:54 PM, Petr Vandrovec wrote:
> Hello,
>   openSUSE11.3 32bit kernels hang when installed to the VMware's VMs because Moorestown
> fixed capabilities detection code enters endless loop on Intel's AGP bridges (with
> device ID=7191).  See https://bugzilla.kernel.org/show_bug.cgi?id=15888 for additional
> details.  arch/x86/pci/mrst.c was introduced after 2.6.33, so only 2.6.34-rcX are
> affected.
> 				Thanks,
> 					Petr Vandrovec

Hi Petr,

Could you check if this patch fixes your problem, and if so let me know
as soon as possible?

Sorry for the delay.

Thanks,

	-hpa

--------------090802020705080501050707
Content-Type: text/x-patch;
 name="mrst-pci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mrst-pci.patch"

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..1cdc02c 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -247,6 +247,10 @@ static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
 	u32 size;
 	int i;
 
+	/* Must have extended configuration space */
+	if (dev->cfg_size < PCIE_CAP_OFFSET + 4)
+		return;
+
 	/* Fixup the BAR sizes for fixed BAR devices and make them unmoveable */
 	offset = fixed_bar_cap(dev->bus, dev->devfn);
 	if (!offset || PCI_DEVFN(2, 0) == dev->devfn ||

--------------090802020705080501050707--
