Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0JVTU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:20:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068Ab0JVTU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:20:56 -0400
Message-ID: <4CC1E40F.60708@zytor.com>
Date: Fri, 22 Oct 2010 12:20:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com> <4CC0CA07.3000306@goop.org> <4CC0DEB8.1060309@zytor.com> <20101022150826.GA23325@dumpdata.com> <4CC1BF58.9020001@zytor.com> <4CC1E0B6.3070303@goop.org>
In-Reply-To: <4CC1E0B6.3070303@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 12:06 PM, Jeremy Fitzhardinge wrote:
> 
> Well, if you want to map a normal memory page, you'd use, say,
> pfn_pte(pfn, PAGE_KERNEL) to generate the pte.  The pfn is a
> domain-local pseudo-physical address.  When it ends up in
> xen_make_pte(), it will translate the the pfn into a machine-global mfn
> to generate a pte_t which can be inserted into a pagetable.  (And when
> that pagetable starts being used as such, Xen will validate that the mfn
> is actually one the domain is allowed to address.)
> 
> However, if you're doing an ioremap(), then the mapped address is a
> hardware one.  In that case, we construct the pte with
> pfn_pte(device_pfn, PAGE_KERNEL_IO), which sets the _PAGE_IOMAP flag in
> the pte flags.  When it gets to xen_make_pte(), it sees _PAGE_IOMAP and
> constructs a pte_t containing the literal untranslated device_pfn
> (really an mfn).  (And again, Xen will check that the domain has access
> to that mfn before allowing the mapping to be used.)
> 

When you're doing an ioremap(), then the mapped address is *both* a PFN
and an MFN, right?  So why do your need a flag?  That is the part I
don't get...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

