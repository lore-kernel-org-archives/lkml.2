Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0JVApx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:45:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36447 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0JVApw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:45:52 -0400
Message-ID: <4CC0DEB8.1060309@zytor.com>
Date: Thu, 21 Oct 2010 17:45:44 -0700
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
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com> <4CC0CA07.3000306@goop.org>
In-Reply-To: <4CC0CA07.3000306@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 04:17 PM, Jeremy Fitzhardinge wrote:
> 
> Xen PV guests are always responsible for constructing ptes with machine
> addresses in them (ie, doing their own pseudo-physical to machine
> address conversion), and Xen verifies that the pages they want to map
> either belong to them or have been granted to them.  The _PAGE_IOMAP
> flag is a kernel-internal one which allows us to distinguish between
> ptes intended to map memory vs machine hardware addresses; it is not
> part of the Xen ABI.
> 
> If you're passing a device through to a domain, the domain is given
> access to the device's address space so it can legally map those pages
> (and if an IOMMU is available, the device is constrained to only DMA
> that domain's memory).
> 

Okay, could you clarify this part a bit?  Why does the kernel need to
know the difference between "pseudo-physical" and "machine addresses" at
all?  If they overlap, there is a problem, and if they don't overlap, it
will be a 1:1 mapping anyway...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

