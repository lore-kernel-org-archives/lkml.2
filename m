Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0IQGBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:01:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0IQGBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:01:12 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Hugh Dickins <hughd@google.com>
Subject: [PATCH v2] Document the new Anonymous field in smaps.
Date: Fri, 17 Sep 2010 11:34:02 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
References: <AANLkTini3k1hK-9RM6io0mOf4VoDzGpbUEpiv=WHfhEW@mail.gmail.com> <201009161135.00129.knikanth@suse.de> <alpine.DEB.2.00.1009160940330.24798@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1009160940330.24798@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009171134.02771.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new Anonymous field in smaps.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..b430576 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -370,17 +370,24 @@ Shared_Dirty:          0 kB
 Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
+Anonymous:             0 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 
-The first  of these lines shows  the same information  as is displayed for the
-mapping in /proc/PID/maps.  The remaining lines show  the size of the mapping,
+The first of these lines shows the same information as is displayed for the
+mapping in /proc/PID/maps. The remaining lines show the size of the mapping,
 the amount of the mapping that is currently resident in RAM, the "proportional
 set size” (divide each shared page by the number of processes sharing it), the
 number of clean and dirty shared pages in the mapping, and the number of clean
-and dirty private pages in the mapping.  The "Referenced" indicates the amount
-of memory currently marked as referenced or accessed.
+and dirty private pages in the mapping. Even pages which are part of
+MAP_SHARED mappings, but has only a single pte mapped i.e., used exclusively
+by a process is accounted as private and not as shared. The "Referenced"
+indicates the amount of memory currently marked as referenced or accessed. The
+"Anonymous" shows the number of pages that is not associated with a file. Even
+mappings associated with a file can have anonymous pages. When the mapping is
+MAP_PRIVATE and its pages are modified, the pages are COWed and marked as
+anonymous.
 
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
