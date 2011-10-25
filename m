Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1JYUId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:08:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:53184 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1JYUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:08:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: xen-devel@lists.xensource.com, david.vrabel@citrix.com
Subject: [PATCH] MMU bug-fixes in generic code that are mostly used by Xen.
Date: Tue, 25 Oct 2011 16:07:56 -0400
Message-Id: <1319573279-13867-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4EA7172A.00DF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if you could help. I've this bug-fix:
 [PATCH 1/3] x86/paravirt: PTE updates in k(un)map_atomic need to be

that you picked up some time ago in your tree and then dropped. I am not sure why it
was dropped but perhaps it is b/c I also had that patch in my linux-next and your tool
decided to drop it. Anyhow, was wondering if you would be OK giving it your
Ack or just pulling it in your tree for 3.2.

These two:
 [PATCH 2/3] xen: use generic functions instead of xen_{alloc,
 [PATCH 3/3] xen: map foreign pages for shared rings by updating the

remove what git commit d2fe97c3315a6a406540f74651e7430d9d51e671
	Author: David Vrabel <david.vrabel@citrix.com>
	Date:   Thu Sep 29 16:53:32 2011 +0100

	    xen: map foreign pages for shared rings by updating the PTEs directly

added in 3.1 with a more selective way instead of using the big hammer.

I was wondering if you would be OK ACK-ing those two or sticking them
in your tree for 3.2.

All of the patches are in:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-akpm-3.2

and the last two have also been sitting for some time in linux-next (and the first
one was there but it looks like I forgot to put it back there as I had thought
that Linus had picked it up.. argh).

 arch/ia64/include/asm/xen/grant_table.h |   29 --------------
 arch/ia64/xen/grant-table.c             |   62 -------------------------------
 arch/x86/include/asm/xen/grant_table.h  |    7 ---
 arch/x86/mm/highmem_32.c                |    2 +
 arch/x86/xen/grant-table.c              |    2 +-
 drivers/xen/xenbus/xenbus_client.c      |   15 +++++--
 include/linux/vmalloc.h                 |    2 +-
 include/xen/grant_table.h               |    1 -
 mm/vmalloc.c                            |   27 ++++++-------
 9 files changed, 27 insertions(+), 120 deletions(-)
