Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0JUWsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:48:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53610 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0JUWsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:48:00 -0400
Message-ID: <4CC0C318.90401@zytor.com>
Date: Thu, 21 Oct 2010 15:47:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org>
In-Reply-To: <4CC0C14E.5080205@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 03:40 PM, Jeremy Fitzhardinge wrote:
> 
> Set _PAGE_IOMAP in ptes mapping a VM_IO vma.  This says that the mapping
> is of a real piece of physical hardware, and not just system memory.
> 
> Xen, in particular, uses to this to inhibit the normal pfn->mfn conversion
> that would normally happen - in other words, treat the address directly
> as a machine physical address without converting it from pseudo-physical.
> 
> [ Impact: make VM_IO mappings map the right thing under Xen ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 

Am I the only one who thinks this seems extremely odd that the guest is
trusted to make this distinction?

	-hpa
