Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0LJUgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:36:15 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:43504 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757176Ab0LJUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:36:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Np5HF1uhm4TPA/rGK5HpM1Q2IiuJKFQLw8GuedcshhYxAQp1+J9k8SWtqfKFcuh6VX0mdgaX/+OkJ529ehQ3p+FGs5+Slzz8eA4kELO4w0rJd2d3iR7TEA0b2QX5KS/U;
Date: Fri, 10 Dec 2010 12:36:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation
 in reserved areas
Message-ID: <20101210123609.73c12a23@jbarnes-desktop>
In-Reply-To: <20101210123008.7fed582d@jbarnes-desktop>
References: <20101208213606.13026.47657.stgit@bob.kio>
	<20101210123008.7fed582d@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Actually cc'ing Matthew this time]

On Fri, 10 Dec 2010 12:30:08 -0800
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wed, 08 Dec 2010 14:36:06 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > 
> > This adds arch_remove_reservations(), which an arch can implement if it
> > needs to protect part of the address space from allocation.
> > 
> > Sometimes that can be done by just requesting a resource.  This hook is to
> > cover cases where protected area doesn't fit well in the hierarchical
> > resource tree.  For example, x86 BIOS E820 reservations are not related
> > to devices, so they may overlap part of, all of, or more than a device
> > resource.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> 
> Hm, this is bigger than the simple change of just avoiding the high 2M;
> Linus have you checked it out yet?  It's nicer than simply adjusting
> PCIBIOS_MAX_MEM since it will affect all resource callers rather than
> just PCI, but it's definitely bigger.
> 
> If you want just the simple change for 2.6.37 I can push that, but
> we'll need to get a tested-by from Matthew:
> 
>   diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
>   index ca0437c..aef9f77 100644
>   --- a/arch/x86/include/asm/pci.h
>   +++ b/arch/x86/include/asm/pci.h
>   @@ -141,7 +141,7 @@ void dma32_reserve_bootmem(void);
> 
>    /* generic pci stuff */
>    #include <asm-generic/pci.h>
>   -#define PCIBIOS_MAX_MEM_32 0xffffffff
>   +#define PCIBIOS_MAX_MEM_32 0xfff00000
> 
>    #ifdef CONFIG_NUMA
>    /* Returns the node based on pci bus */
> 
> and I'll queue up this set for 2.6.38.
> 
> Thanks,


-- 
Jesse Barnes, Intel Open Source Technology Center
