Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2FSIdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:33:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60912 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FSIdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:33:54 -0400
Message-ID: <4FE03961.5050001@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:33:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 03/10] zcache: fix a compile warning
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12061823-3568-0000-0000-000001FDE884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix:

drivers/staging/zcache/zcache-main.c: In function ‘zcache_comp_op’:
drivers/staging/zcache/zcache-main.c:112:2: warning: ‘ret’ may be used uninitial

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 32fe0ba..74a3ac8 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -93,7 +93,7 @@ static inline int zcache_comp_op(enum comp_op op,
 				u8 *dst, unsigned int *dlen)
 {
 	struct crypto_comp *tfm;
-	int ret;
+	int ret = -1;

 	BUG_ON(!zcache_comp_pcpu_tfms);
 	tfm = *per_cpu_ptr(zcache_comp_pcpu_tfms, get_cpu());
-- 
1.7.7.6

