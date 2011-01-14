Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1ANWPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:15:30 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:51734 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751519Ab1ANWP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:15:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ibK31amrXs4Eimog3cwzq3iz/TKtTxyIuO0YKW4aUc88hI7mU+qkghqTiwL8N/nIa1/0GTR8w3Yeq1R45l08BoplCCy7KtOyae4F7wuMQ3X/FCJ+1auNTWF7xEjP79RK;
Date: Fri, 14 Jan 2011 14:15:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes (link error)
Message-ID: <20110114141526.10546dd5@jbarnes-desktop>
In-Reply-To: <20110114221300.GA2366@gentoo.trippels.de>
References: <20110114090150.0a212030@jbarnes-desktop>
	<20110114193731.GA2381@gentoo.trippels.de>
	<201101142301.09624.rjw@sisk.pl>
	<20110114221300.GA2366@gentoo.trippels.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 23:13:00 +0100
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2011.01.14 at 23:01 +0100, Rafael J. Wysocki wrote:
> > On Friday, January 14, 2011, Markus Trippelsdorf wrote:
> > > On 2011.01.14 at 09:01 -0800, Jesse Barnes wrote:
> > > > ...
> > > > 
> > > > Rafael J. Wysocki (5):
> > > >       PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
> > > >       PCI/PCIe: Clear Root PME Status bits early during system resume
> > > >       PCI/ACPI: Request _OSC control once for each root bridge (v3)
> > > 
> > > This breaks the build if CONFIG_PCIEPORTBUS is not set:
> > > 
> > > ld: drivers/built-in.o: in function acpi_pci_root_add:pci_root.c(.devinit.text+0x2633): error: undefined reference to 'pcie_ports_disabled'
> > 
> > Does the appended patch help?
> 
> > +#ifdef CONFIG_PCIEPORTBUS
> >  extern bool pcie_ports_disabled;
> >  extern bool pcie_ports_auto;
> > +#else
> > +#define pcie_ports_disabled	true
> > +#define bool pcie_ports_auto	false
> > +#endif
> 
> No, but this one does ;-):
> 
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9e67dcd..0f4ca55 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -993,8 +993,13 @@ extern void pci_restore_msi_state(struct pci_dev *dev);
>  extern int pci_msi_enabled(void);
>  #endif
>  
> +#ifdef CONFIG_PCIEPORTBUS
>  extern bool pcie_ports_disabled;
>  extern bool pcie_ports_auto;
> +#else
> +#define pcie_ports_disabled true
> +#define pcie_ports_auto false
> +#endif
>  
>  #ifndef CONFIG_PCIEASPM
>  static inline int pcie_aspm_enabled(void)
> 

Linus, can you just take this directly so the link error isn't in your
tree any longer than necessary?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
