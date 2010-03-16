Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0CPFvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:51:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58584 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab0CPFvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:51:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] tmpfs: handle MPOL_LOCAL mount option properly
Cc: kosaki.motohiro@jp.fujitsu.com, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk,
       lee.schermerhorn@hp.com, mel@csn.ul.ie, stable@kernel.org,
       linux-mm <linux-mm@kvack.org>, akpm@linux-foundation.org
In-Reply-To: <20100316143406.4C45.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org> <20100316143406.4C45.A69D9226@jp.fujitsu.com>
Message-Id: <20100316145022.4C4E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Mar 2010 14:51:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 71fe804b6d5 (mempolicy: use struct mempolicy pointer in
shmem_sb_info) added mpol=local mount option. but its feature is
broken since it was born. because such code always return 1 (i.e.
mount failure).

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: <stable@kernel.org>
---
 mm/mempolicy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3f77062..5c197d5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2212,6 +2212,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
+		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
-- 
1.6.5.2



