Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2LKOl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:41:56 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:51947 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab2LKOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:41:55 -0500
Date: Tue, 11 Dec 2012 09:41:39 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Vivek Goyal <vgoyal@redhat.com>
Message-ID: <1672785544.45808556.1355236899164.JavaMail.root@redhat.com>
In-Reply-To: <CAAmzW4NHO=y=utmK_at+JxvyYMd4O_7W_6n541GEA0aeDfukyw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] remove vm_struct list management
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.187.10]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----

> > Can we get the same information from this rb-tree of vmap_area? Is
> > ->va_start field communication same information as vmlist was
> > communicating? What's the difference between vmap_area_root and vmlist.
> 
> Thanks for comment.
> 
> Yes. vmap_area's va_start field represent same information as vm_struct's addr.
> vmap_area_root is data structure for fast searching an area.
> vmap_area_list is address sorted list, so we can use it like as vmlist.
> 
> There is a little difference vmap_area_list and vmlist.
> vmlist is lack of information about some areas in vmalloc address space.
> For example, vm_map_ram() allocate area in vmalloc address space,
> but it doesn't make a link with vmlist. To provide full information
> about vmalloc address space, using vmap_area_list is more adequate.
> 
> > So without knowing details of both the data structures, I think if vmlist
> > is going away, then user space tools should be able to traverse vmap_area_root
> > rb tree. I am assuming it is sorted using ->addr field and we should be
> > able to get vmalloc area start from there. It will just be a matter of
> > exporting right fields to user space (instead of vmlist).
> 
> There is address sorted list of vmap_area, vmap_area_list.
> So we can use it for traversing vmalloc areas if it is necessary.
> But, as I mentioned before, kexec write *just* address of vmlist and
> offset of vm_struct's address field.  It imply that they don't traverse vmlist,
> because they didn't write vm_struct's next field which is needed for traversing.
> Without vm_struct's next field, they have no method for traversing.
> So, IMHO, assigning dummy vm_struct to vmlist which is implemented by [7/8] is
> a safe way to maintain a compatibility of userspace tool. :)

Why bother keeping vmlist around?  kdump's makedumpfile command would not
even need to traverse the vmap_area rbtree, because it could simply look
at the first vmap_area in the sorted vmap_area_list, correct?

Dave Anderson


