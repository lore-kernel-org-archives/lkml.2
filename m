Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2FSIfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:35:23 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46767 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2FSIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:35:18 -0400
Message-ID: <4FE039BE.6010406@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:35:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 05/10] zcache: mark zbud_init/zcache_comp_init as __init
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061822-5140-0000-0000-00000198E44D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are called only when system is initializing, so mark __init
for them to free memory

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 82d752d..d194303 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -594,7 +594,7 @@ out:
 	return;
 }

-static void zbud_init(void)
+static void __init zbud_init(void)
 {
 	int i;

@@ -1974,7 +1974,7 @@ static int __init enable_zcache_compressor(char *s)
 __setup("zcache=", enable_zcache_compressor);


-static int zcache_comp_init(void)
+static int __init zcache_comp_init(void)
 {
 	int ret = 0;

-- 
1.7.7.6

