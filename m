Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2JBLqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:46:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29540 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2JBLqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:46:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,523,1344211200"; 
   d="scan'208";a="14890821"
Date: Tue, 2 Oct 2012 12:45:01 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the xen-two tree with Linus' tree
In-Reply-To: <506AEE0C020000780009F0A1@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1210021240020.29232@kaball.uk.xensource.com>
References: <20121002141949.f6e61437bdce0d56d9d4321e@canb.auug.org.au> <alpine.DEB.2.02.1210021141370.29232@kaball.uk.xensource.com> <506AEE0C020000780009F0A1@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Jan Beulich wrote:
> >>> On 02.10.12 at 12:44, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >> --- a/drivers/xen/Makefile
> >> +++ b/drivers/xen/Makefile
> >> @@@ -4,8 -8,11 +8,12 @@@ obj-y	+= xenbus
> >>   nostackp := $(call cc-option, -fno-stack-protector)
> >>   CFLAGS_features.o			:= $(nostackp)
> >>   
> >> + obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
> >> + dom0-$(CONFIG_PCI) += pci.o
> >> ++dom0-$(CONFIG_X86) += dbgp.o
> >> + dom0-$(CONFIG_ACPI) += acpi.o
> >> + dom0-$(CONFIG_X86) += pcpu.o
> >>   obj-$(CONFIG_BLOCK)			+= biomerge.o
> >> - obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
> >>   obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
> >>   obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
> >>   obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o
> >  
> > 
> > Considering that dbgp doesn't seem to be very useful without PCI at the
> > moment, could we just turn it into:
> > 
> > dom0-$(CONFIG_PCI) += dbgp.o
> > 
> > ?
> 
> Better not - the code is specifically not PCI-only. And I can't see
> how it would be harmful to be compiled on e.g. ARM (so the
> merge perhaps really should use XEN_DOM0 alone, without
> X86. If anything (and that may indeed be a minor oversight of
> the original patch) one might want it to depend on USB_SUPPORT,
> as without that no in-tree debug port capable driver would be
> able to load (and hence interfere with Xen's use of the debug
> port). However, as long as it builds fine with USB_SUPPORT
> undefined (which I believe it does), having it in the shape it
> is allows for out-of-tree drivers as well (as long as they make
> use of the designated interface).

OK for PCI.
Regarding USB_SUPPORT, considering that gbgp.c calls hcd_to_bus, I think
it would make sense to make it depend on it.
