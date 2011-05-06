Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1EFLdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 07:33:18 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:33975 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1EFLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 07:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=iM7gFWKFTmkPij/cBV92edwbegbtRTfgF0RsTp+oZzeXTDC8q3v6gGZEGsGUYqVaLr
         r87J53J37OuHmOI7F0Bqjnuao+nan1XWtidNrbPlQr+0tzedNvdVneG0vcd0KIBHJD2b
         eSvnY735DKUYE6/PF0Aan7ft06ldFG73lY4ws=
Subject: [PATCH]mm/compation.c: checking page in lru twice
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, kamezawa.hiroyu@jp.fujisu.com,
        minchan.kim@gmail.com, Andrew Morton <akpm@osdl.org>,
        aarcange@redhat.com
Date: Fri, 06 May 2011 19:32:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 7bit
Message-ID: <1304681575.15473.4.camel@figo-desktop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in isolate_migratepages() have check page in LRU twice, the next one
at _isolate_lru_page(). 

Signed-off-by: Figo.zhang <figo1802@gmail.com> 
---

mm/compaction.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 021a296..ac605cb 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -321,9 +321,6 @@ static unsigned long isolate_migratepages(struct zone *zone,
 			continue;
 		}
 
-		if (!PageLRU(page))
-			continue;
-
 		/*
 		 * PageLRU is set, and lru_lock excludes isolation,
 		 * splitting and collapsing (collapsing has already


