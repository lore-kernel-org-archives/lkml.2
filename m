Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3ABOYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:24:22 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:8295 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab3ABOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:24:19 -0500
Date: Wed, 2 Jan 2013 14:24:17 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        akpm@linux-foundation.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 04/14] memory-hotplug: remove /sys/firmware/memmap/X
 sysfs
In-Reply-To: <50DBBBEF.70701@cn.fujitsu.com>
Message-ID: <0000013bfba5f7f2-ba70da31-0707-48fd-949e-0bad11ba0e10-000000@email.amazonses.com>
References: <1356350964-13437-1-git-send-email-tangchen@cn.fujitsu.com> <1356350964-13437-5-git-send-email-tangchen@cn.fujitsu.com> <50DA6F5A.2070601@jp.fujitsu.com> <50DBBBEF.70701@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012, Tang Chen wrote:

> On 12/26/2012 11:30 AM, Kamezawa Hiroyuki wrote:
> >> @@ -41,6 +42,7 @@ struct firmware_map_entry {
> >>    	const char		*type;	/* type of the memory range */
> >>    	struct list_head	list;	/* entry for the linked list */
> >>    	struct kobject		kobj;   /* kobject for each entry */
> >> +	unsigned int		bootmem:1; /* allocated from bootmem */
> >>    };
> >
> > Can't we detect from which the object is allocated from, slab or bootmem ?
> >
> > Hm, for example,
> >
> >      PageReserved(virt_to_page(address_of_obj)) ?
> >      PageSlab(virt_to_page(address_of_obj)) ?
> >
>
> Hi Kamezawa-san,
>
> I think we can detect it without a new member. I think bootmem:1 member
> is just for convenience. I think I can remove it. :)

Larger size slab allocations may fall back to the page allocator but then
the slabs do not track this allocation. That memory can be freed using the
page allocator.

If you see pageslab then you can always remove using the slab allocator.
Otherwise the page allocator should work (unless it was some
special case bootmem allocation).

