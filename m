Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1DUThN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:37:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1DUThM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:37:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: brace@beardog.cce.hp.com
Subject: Re: How to create a kernel virtual mapping for physical addresses.
Date: Thu, 21 Apr 2011 21:36:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: scameron@beardog.cce.hp.com, linux-kernel@vger.kernel.org
References: <20110408220321.GA777@beardog.cce.hp.com> <201104192151.41511.arnd@arndb.de> <20110421184600.GA29746@beardog.cce.hp.com>
In-Reply-To: <20110421184600.GA29746@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104212136.38017.arnd@arndb.de>
X-Provags-ID: V02:K0:k2Mqvqt6csHrKVtqTOosEeFpa45Jg0dAjwOX9ITO1v/
 W0UubCeJClXuC9q68QAZ6s1gcFoDYtG4Pc8dqYgaxRn0CrmmFU
 TIdOduD1F6tLxYrD57hw5EjsV0Qb+9ps6ZSmd5a1Ypent6wL3s
 mrcVIss40EnV6BD5Evj6QMbXgXAoP4d7+CnOOOCEkzicBkH6kB
 lli0E1oyTTSAv5n5G2xfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011 20:46:00 brace@beardog.cce.hp.com wrote:
> Thanks for your reply.
> 
> I have a block of highmem that I want to map into my 32bit driver.
> This block is 256M in size.

If you have highmem enabled, there probably is not enough space
to map all of this at once into the vmalloc area. If you had
that much virtual address space, you would not need highmem ;-)

> I get the physical address and want to create a contiguous virtual buffer.
> I have been investigating vmap() as a possible solution.
> 
> I build up an array of pages as follows.
> 	pfn = physical_address >> PAGE_SHIFT
> 	for (i = 0; i < num_pages; i++) {
> 		page = pfn_to_page(pfn);
> 		page_array[i] = page;
> 		++pfn
> 	}
> 
> 	map = vmap(page_array, num_pages, VM_IOREMAP, PAGE_KERNEL);
> 
> Using the above method, I can memset the block of memory using
> map as my virtual address.
> 
> However, later, I get the following error message:
> 
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle kernel paging request at virtual address c5000840
> 
> The address 0xc5000840 is within the range of vmap()ed memory.

Maybe you have overwritten a kernel module and the kernel now
tries to execute within the mapped area?

> What should I be doing instead?

It's not clear at all what you are actually trying to do. Which driver
is this? If it's out-of-tree code, please post it here.

	Arnd
