Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1ANWNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:13:06 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:54450 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1ANWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:13:03 -0500
Date: Fri, 14 Jan 2011 23:13:00 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes (link error)
Message-ID: <20110114221300.GA2366@gentoo.trippels.de>
References: <20110114090150.0a212030@jbarnes-desktop>
 <20110114193731.GA2381@gentoo.trippels.de>
 <201101142301.09624.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101142301.09624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.01.14 at 23:01 +0100, Rafael J. Wysocki wrote:
> On Friday, January 14, 2011, Markus Trippelsdorf wrote:
> > On 2011.01.14 at 09:01 -0800, Jesse Barnes wrote:
> > > ...
> > > 
> > > Rafael J. Wysocki (5):
> > >       PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
> > >       PCI/PCIe: Clear Root PME Status bits early during system resume
> > >       PCI/ACPI: Request _OSC control once for each root bridge (v3)
> > 
> > This breaks the build if CONFIG_PCIEPORTBUS is not set:
> > 
> > ld: drivers/built-in.o: in function acpi_pci_root_add:pci_root.c(.devinit.text+0x2633): error: undefined reference to 'pcie_ports_disabled'
> 
> Does the appended patch help?

> +#ifdef CONFIG_PCIEPORTBUS
>  extern bool pcie_ports_disabled;
>  extern bool pcie_ports_auto;
> +#else
> +#define pcie_ports_disabled	true
> +#define bool pcie_ports_auto	false
> +#endif

No, but this one does ;-):


diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9e67dcd..0f4ca55 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -993,8 +993,13 @@ extern void pci_restore_msi_state(struct pci_dev *dev);
 extern int pci_msi_enabled(void);
 #endif
 
+#ifdef CONFIG_PCIEPORTBUS
 extern bool pcie_ports_disabled;
 extern bool pcie_ports_auto;
+#else
+#define pcie_ports_disabled true
+#define pcie_ports_auto false
+#endif
 
 #ifndef CONFIG_PCIEASPM
 static inline int pcie_aspm_enabled(void)

-- 
Markus
