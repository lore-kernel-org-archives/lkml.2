Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0ELB31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:29:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37298 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0ELB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:29:25 -0400
Message-ID: <4BEA0472.1060300@jp.fujitsu.com>
Date: Wed, 12 May 2010 10:29:22 +0900
From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: dm-devel@redhat.com, agk@redhat.com
CC: linux-kernel@vger.kernel.org, kusumi.tomohiro@jp.fujitsu.com
Subject: [PATCH] fix hard-coded disk header chunk size for persistent snapshot
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes hard-coded value for the size of a chunk that includes
disk header for persistent snapshot. It should be changed to existing
macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.

Thanks,
Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c
--- linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c        2010-05-10 10:36:28.000000000 +0900
+++ linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c    2010-05-12 09:21:50.000000000 +0900
@@ -266,7 +266,7 @@
  */
 static chunk_t area_location(struct pstore *ps, chunk_t area)
 {
-       return 1 + ((ps->exceptions_per_area + 1) * area);
+       return NUM_SNAPSHOT_HDR_CHUNKS + ((ps->exceptions_per_area + 1) * area);
 }
 
 /*

