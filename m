Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0LRA6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:58:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381Ab0LRA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:58:48 -0500
Date: Fri, 17 Dec 2010 16:58:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-16-14-56 uploaded (hugetlb)
Message-Id: <20101217165834.447cc096.akpm@linux-foundation.org>
In-Reply-To: <4D0C0043.7090408@oracle.com>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
	<20101217143316.fa36be7d.randy.dunlap@oracle.com>
	<20101217145334.3d67d80b.akpm@linux-foundation.org>
	<20101217233740.GR1671@random.random>
	<4D0C0043.7090408@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 16:28:51 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On 12/17/10 15:37, Andrea Arcangeli wrote:
> > Hello,
> > 
> > On Fri, Dec 17, 2010 at 02:53:34PM -0800, Andrew Morton wrote:
> >> afacit, CONFIG_HUGETLBFS must be enabled if CONFIG_HUGETLB_PAGE=y, and
> >> thp-config_transparent_hugepage.patch broke that, by permitting
> >> CONFIG_HUGETLBFS=n, CONFIG_HUGETLB_PAGE=y,
> >> CONFIG_TRANSPARENT_HUGEPAGE=y.
> > 
> > CONFIG_HUGETLBFS and CONFIG_HUGETLB_PAGE existed before, and
> > HUGETLBFS=n && HUGETLB_PAGE=y used to build just fine, I clearly
> > didn't try a build with HUGETLBFS=n recently.
> > 
> >> There's lots of stuff in hugetlb.h which is clearly related to
> >> hugetlbfs, but is enabled by CONFIG_HUGETLB_PAGE, so those things seem
> >> to be pretty joined at the hip nowadays.
> > 
> > Yes, it used to build just fine but I guess after the last hugetlbfs
> > updates I'm getting flood of errors no matter how I adjust things.
> > hugetlbfs code who needs some fixup here.
> 
> I see a real *flood* of errors when I try building ARCH=um SUBARCH={i386|x86_64}:
> 
> > grep -c error: UM*/build*
> UM32/build-defcfg.out:454539
> UM64/build-defcfg.out:453707

erk, yeah, that's totally horked.

The first one millionth:

include/asm-generic/pgtable.h: In function 'ptep_get_and_clear':
include/asm-generic/pgtable.h:77: error: expected statement before ')' token
include/asm-generic/pgtable.h:94: error: invalid storage class for function 'pmdp_get_and_clear'

Due to thp-add-pmd-mangling-generic-functions.patch
