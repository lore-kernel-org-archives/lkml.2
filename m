Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2KAMt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:49:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46865 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab2KAMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:49:54 -0400
Date: Thu, 1 Nov 2012 08:49:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Rientjes <rientjes@google.com>, JBeulich@suse.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, xen: fix build dependency when USB_SUPPORT is not
 enabled
Message-ID: <20121101124912.GA10743@localhost.localdomain>
References: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:42:30PM -0700, David Rientjes wrote:
> CONFIG_XEN_DOM0 must depend on CONFIG_USB_SUPPORT, otherwise there is no 
> definition of xen_dbgp_reset_prep() and xen_dbgp_external_startup() 
> resulting in the following link error:
> 
> drivers/built-in.o: In function `dbgp_reset_prep':
> (.text+0x1e03c5): undefined reference to `xen_dbgp_reset_prep'
> drivers/built-in.o: In function `dbgp_external_startup':
> (.text+0x1e0d55): undefined reference to `xen_dbgp_external_startup'

There is another patch that needs to be Acked and picked up by
Greg KH that fixes this.

Let me poke Jan Beulich to repost it with the appropiate Acks.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/xen/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -17,6 +17,7 @@ config XEN_DOM0
>  	def_bool y
>  	depends on XEN && PCI_XEN && SWIOTLB_XEN
>  	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
> +	depends on USB_SUPPORT
>  
>  # Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
>  # name in tools.
