Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2GaMXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:23:04 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39228 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab2GaMXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:23:00 -0400
Date: Tue, 31 Jul 2012 14:22:51 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 16/19] memory-hotplug: free memmap of
 sparse-vmemmap
Message-ID: <20120731142251.5b2cae37@thinkpad>
In-Reply-To: <50126EBE.1020006@cn.fujitsu.com>
References: <50126B83.3050201@cn.fujitsu.com>
	<50126EBE.1020006@cn.fujitsu.com>
Reply-To: gerald.schaefer@de.ibm.com
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12073112-5024-0000-0000-000003622A56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 18:34:38 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> All pages of virtual mapping in removed memory cannot be freed, since
> some pages used as PGD/PUD includes not only removed memory but also
> other memory. So the patch checks whether page can be freed or not.
> 
> How to check whether page can be freed or not?
>  1. When removing memory, the page structs of the revmoved memory are
> filled with 0FD.
>  2. All page structs are filled with 0xFD on PT/PMD, PT/PMD can be
> cleared. In this case, the page used as PT/PMD can be freed.
> 
> Applying patch, __remove_section() of CONFIG_SPARSEMEM_VMEMMAP is
> integrated into one. So __remove_section() of
> CONFIG_SPARSEMEM_VMEMMAP is deleted.

There should also be generic or dummy versions of the functions
vmemmap_free_bootmem(), vmemmap_kfree() and
register_page_bootmem_memmap(). It doesn't compile on other
archtitectures than x86 as it is now:

mm/built-in.o: In function `sparse_remove_one_section':
(.text+0x49fa6): undefined reference to `vmemmap_free_bootmem'
mm/built-in.o: In function `sparse_remove_one_section':
(.text+0x49fcc): undefined reference to `vmemmap_kfree'
mm/built-in.o: In function `register_page_bootmem_info_node':
(.text+0x57c06): undefined reference to `register_page_bootmem_memmap'
mm/built-in.o: In function `sparse_add_one_section':
(.meminit.text+0x2506): undefined reference to `vmemmap_kfree'
mm/built-in.o: In function `sparse_add_one_section':
(.meminit.text+0x2528): undefined reference to `vmemmap_kfree'
make: *** [vmlinux] Error 1

