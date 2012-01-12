Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2ALUij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:38:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:50151 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2ALUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:38:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nitin Gupta <ngupta@vflare.org>,
        Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
        Rik Riel <riel@redhat.com>
Subject: [PATCH 4/4] mm: cleancache: Use __read_mostly as appropiate.
Date: Thu, 12 Jan 2012 15:36:20 -0500
Message-Id: <1326400580-16853-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
References: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F0F44BC.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

The values are rarely changed so might as well put them in the
appropiate section.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Rik Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/cleancache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/cleancache.c b/mm/cleancache.c
index deb9f2c..5646c74 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -25,14 +25,14 @@
  * disabled), so is preferred to the slower alternative: a function
  * call that checks a non-global.
  */
-int cleancache_enabled;
+int cleancache_enabled __read_mostly;
 EXPORT_SYMBOL(cleancache_enabled);
 
 /*
  * cleancache_ops is set by cleancache_ops_register to contain the pointers
  * to the cleancache "backend" implementation functions.
  */
-static struct cleancache_ops cleancache_ops;
+static struct cleancache_ops cleancache_ops __read_mostly;
 
 /*
  * Counters available via /sys/kernel/debug/frontswap (if debugfs is
-- 
1.7.7.4

