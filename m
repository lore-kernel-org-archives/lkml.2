Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab1EZTnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:43:31 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33452 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1EZTna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:43:30 -0400
Date: Thu, 26 May 2011 21:43:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: "mm: don't access vm_flags as 'int'" build failure
Message-ID: <20110526194328.GA1749@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ca16d140 (mm: don't access vm_flags as 'int') breaks the build
for me:

  CC      fs/proc/meminfo.o
In file included from fs/proc/meminfo.c:2:0:
include/linux/hugetlb.h:195:3: error: unknown type name ‘vm_flags_t’

This fixes the problem:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cf8931e..665f854 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
+#include <linux/mm_types.h>
 
 struct ctl_table;
 struct user_struct;

-- 
Markus
