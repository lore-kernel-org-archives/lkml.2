Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2KGAjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 19:39:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43204 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2KGAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 19:39:14 -0500
Date: Wed, 7 Nov 2012 01:39:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mtk.manpages@gmail.com,
        Andi Kleen <ak@linux.intel.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v7
Message-ID: <20121107003905.GA16230@one.firstfloor.org>
References: <1352157848-29473-1-git-send-email-andi@firstfloor.org> <1352157848-29473-2-git-send-email-andi@firstfloor.org> <20121106132737.c2aa3c47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106132737.c2aa3c47.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 01:27:37PM -0800, Andrew Morton wrote:
> On Mon,  5 Nov 2012 15:24:08 -0800
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > There was some desire in large applications using MAP_HUGETLB/SHM_HUGETLB
> > to use 1GB huge pages on some mappings, and stay with 2MB on others. This
> > is useful together with NUMA policy: use 2MB interleaving on some mappings,
> > but 1GB on local mappings.
> > 
> > This patch extends the IPC/SHM syscall interfaces slightly to allow specifying
> > the page size.
> > 
> > It borrows some upper bits in the existing flag arguments and allows encoding
> > the log of the desired page size in addition to the *_HUGETLB flag.
> > When 0 is specified the default size is used, this makes the change fully
> > compatible.
> > 
> > Extending the internal hugetlb code to handle this is straight forward. Instead
> > of a single mount it just keeps an array of them and selects the right
> > mount based on the specified page size. When no page size is specified
> > it uses the mount of the default page size.
> > 
> > The change is not visible in /proc/mounts because internal mounts
> > don't appear there. It also has very little overhead: the additional
> > mounts just consume a super block, but not more memory when not used.
> > 
> > I also exported the new flags to the user headers
> > (they were previously under __KERNEL__). Right now only symbols
> > for x86 and some other architecture for 1GB and 2MB are defined.
> > The interface should already work for all other architectures
> > though.  Only architectures that define multiple hugetlb sizes
> > actually need it (that is currently x86, tile, powerpc). However
> > tile and powerpc have user configurable hugetlb sizes, so it's
> > not easy to add defines. A program on those architectures would
> > need to query sysfs and use the appropiate log2.
> 
> I can't say the userspace interface is a thing of beauty, but I guess
> we'll live.

Thanks.

> 
> Did you have a test app?  If so, can we get it into
> tools/testing/selftests and point the arch maintainers at it?

Yes I do. I'll send a patch separately.

However you have to run with the right options and it may 
be slightly x86 specific.

>  	unregister_filesystem(&hugetlbfs_fs_type);
>  	bdi_destroy(&hugetlbfs_backing_dev_info);
> 
> (we're not supposed to split strings like that, but screw 'em!)

Thanks I assume you handle that.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
