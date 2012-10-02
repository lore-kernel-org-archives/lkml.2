Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2JBPZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:25:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57093 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2JBPZF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 2 Oct 2012 11:25:05 -0400
Message-Id: <506B236C020000780009F281@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 02 Oct 2012 16:25:00 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <sfr@canb.auug.org.au>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/Makefile: resolve merge conflict with
 9fa5780beea1
References: <alpine.DEB.2.02.1210021606000.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1210021606000.29232@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.10.12 at 17:13, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> This patch is actually a merge conflict resolution between Konrad's Xen
> tree and the following commit:
> 
> commit 9fa5780beea1274d498a224822397100022da7d4
> Author: Jan Beulich <JBeulich@suse.com>
> Date:   Tue Sep 18 12:23:02 2012 +0100
> 
>     USB EHCI/Xen: propagate controller reset information to hypervisor
> 
> 
> Compile dbgp.o only if CONFIG_USB is defined.

Now this is wrong: USB is a tristate config option, yet dbgp.o
must be built in. This is why I suggested to use USB_SUPPORT
(if anything at all).

Jan

> After all xen_dbgp_op relies on hcd_to_bus.
> 
> This patch should be applied on top of 
> 
> http://marc.info/?l=linux-kernel&m=134919011231980&w=2 
> 
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --cc drivers/xen/Makefile
> index a4a3cab,275abfc..33711ad
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@@ -4,8 -8,11 +8,12 @@@ obj-y	+= xenbus
>   nostackp := $(call cc-option, -fno-stack-protector)
>   CFLAGS_features.o			:= $(nostackp)
>   
> + dom0-$(CONFIG_PCI) += pci.o
> + dom0-$(CONFIG_ACPI) += acpi.o
> + dom0-$(CONFIG_X86) += pcpu.o
> ++dom0-$(CONFIG_USB) += dbgp.o
> + obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
>   obj-$(CONFIG_BLOCK)			+= biomerge.o
> - obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>   obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
>   obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
>   obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o



