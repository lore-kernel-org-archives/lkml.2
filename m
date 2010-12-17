Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0LQWxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:53:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026Ab0LQWxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:53:48 -0500
Date: Fri, 17 Dec 2010 14:53:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: mmotm 2010-12-16-14-56 uploaded (hugetlb)
Message-Id: <20101217145334.3d67d80b.akpm@linux-foundation.org>
In-Reply-To: <20101217143316.fa36be7d.randy.dunlap@oracle.com>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
	<20101217143316.fa36be7d.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 14:33:16 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 16 Dec 2010 14:56:39 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.37-rc6:
> 
> 
> # CONFIG_HUGETLBFS is not set
> CONFIG_HUGETLB_PAGE=y
> 
> 
> In file included from mmotm-2010-1216-1456/kernel/fork.c:36:
> mmotm-2010-1216-1456/include/linux/hugetlb.h: In function 'hstate_inode':
> mmotm-2010-1216-1456/include/linux/hugetlb.h:255: error: implicit declaration of function 'HUGETLBFS_SB'
> 

afacit, CONFIG_HUGETLBFS must be enabled if CONFIG_HUGETLB_PAGE=y, and
thp-config_transparent_hugepage.patch broke that, by permitting
CONFIG_HUGETLBFS=n, CONFIG_HUGETLB_PAGE=y,
CONFIG_TRANSPARENT_HUGEPAGE=y.

I suppose CONFIG_TRANSPARENT_HUGEPAGE could select CONFIG_HUGETLBFS,
but is there a nicer way?


There's lots of stuff in hugetlb.h which is clearly related to
hugetlbfs, but is enabled by CONFIG_HUGETLB_PAGE, so those things seem
to be pretty joined at the hip nowadays.
