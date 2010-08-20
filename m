Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0HTIwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:52:18 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51398 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0HTIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:52:16 -0400
Message-ID: <4C6E4229.4050702@linux.vnet.ibm.com>
Date: Fri, 20 Aug 2010 14:21:53 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jens Axobe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <righi.andrea@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: [PATCH]Fix return code for mkdir calls
Content-Type: multipart/mixed;
 boundary="------------010904080608000603050104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010904080608000603050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch fixes the return value when the cgroup hierarchy for blkio 
control groups is deeper than two levels. Right now EINVAL is returned. 
This patch replaces EINVAL with more appropriate EPERM to align with 
mkdir system call return values. This was discussed between Vivek and 
Daniel sometime back. Please consider this patch for inclusion in 2.6.36.

Thanks
Ciju


--------------010904080608000603050104
Content-Type: text/plain;
 name="blkio-Fix-the-return-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blkio-Fix-the-return-code.patch"

>From bd2b65775a5b187f7c15c2b6d88f47cd24fb9c4e Mon Sep 17 00:00:00 2001
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Date: Fri, 20 Aug 2010 12:02:45 +0530
Subject: blkio: Fix return code for mkdir calls

If the cgroup hierarchy for blkio control groups is deeper than two
levels, kernel should not allow the creation of further levels. mkdir
system call does not except EINVAL as a return value. This patch
replaces EINVAL with more appropriate EPERM

Signed-off-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
---
 block/blk-cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a680964..2fef1ef 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -966,7 +966,7 @@ blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 
 	/* Currently we do not support hierarchy deeper than two level (0,1) */
 	if (parent != cgroup->top_cgroup)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-EPERM);
 
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
-- 
1.6.0.6



--------------010904080608000603050104--
