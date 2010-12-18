Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0LRHpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 02:45:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0LRHpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 02:45:05 -0500
Date: Sat, 18 Dec 2010 08:44:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-16-14-56 uploaded (hugetlb)
Message-ID: <20101218074456.GW1671@random.random>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
 <20101217143316.fa36be7d.randy.dunlap@oracle.com>
 <20101217145334.3d67d80b.akpm@linux-foundation.org>
 <20101217233740.GR1671@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217233740.GR1671@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:37:40AM +0100, Andrea Arcangeli wrote:
> Yes, it used to build just fine but I guess after the last hugetlbfs
> updates I'm getting flood of errors no matter how I adjust things.
> hugetlbfs code who needs some fixup here.

here's the fix (luckily I didn't need to touch a bit of
hugetlbfs). I think initially the only thing I was reusing sometime
was pmd_huge that made me want HUGETLBFS_PAGE (these days there's
pmd_trans_huge and pmd_huge must only be used in hugetlbfs paths, 99%
of the time they're separated). At the time it happened to build with
HUGETLBFS_PAGE=y and HUGETLBFS=n, now it's a total mixture and letting
HUGETLBFS_PAGE live seems bad idea.

====
Subject: thp: remove dependency on HUGETLB_PAGE

From: Andrea Arcangeli <aarcange@redhat.com>

THP code is already 100% standalone and not depending on a bit of hugetlbfs.

HUGETLBFS_PAGE would be better removed and unified with HUGETLBFS considering
the kernel won't build if they're not equal.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -147,7 +147,7 @@ config HUGETLBFS
 	  If unsure, say N.
 
 config HUGETLB_PAGE
-	def_bool HUGETLBFS || TRANSPARENT_HUGEPAGE
+	def_bool HUGETLBFS
 
 source "fs/configfs/Kconfig"
 
