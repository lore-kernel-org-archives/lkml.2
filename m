Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0FJFL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:11:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51628 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab0FJFLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:11:23 -0400
Date: Thu, 10 Jun 2010 15:11:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Huang Ying <ying.huang@intel.com>,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
       Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: linux-next: manual merge of the hwpoison tree with the kvm tree
Message-Id: <20100610151115.8019d072.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Today's linux-next merge of the hwpoison tree got a conflict in
mm/memory-failure.c between commit
7c5663142a8e9fbf31c82fc9ab6ebc3fda10d6b9 ("KVM: Avoid killing userspace
through guest SRAO MCE on unmapped pages") from the kvm tree and commit
2164d3b53f002264d760c76799958ad7a48b9f41 ("HWPOISON, hugetlb: enable
error handling path for hugepage") from the hwpoison tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memory-failure.c
index 378b0f6,d0b420a..0000000
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@@ -45,7 -45,7 +45,8 @@@
  #include <linux/page-isolation.h>
  #include <linux/suspend.h>
  #include <linux/slab.h>
 +#include <linux/swapops.h>
+ #include <linux/hugetlb.h>
  #include "internal.h"
  
  int sysctl_memory_failure_early_kill __read_mostly = 0;
