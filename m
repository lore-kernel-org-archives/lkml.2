Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2KBQBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:01:34 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:62509 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab2KBQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:01:31 -0400
Message-ID: <5093EE54.3020607@gmail.com>
Date: Sat, 03 Nov 2012 00:01:24 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: steffen.klassert@secunet.com, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: [PATCH v2 3/9] net: xfrm: use __this_cpu_read per-cpu helper
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 net/xfrm/xfrm_ipcomp.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index e5246fb..394d672 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -276,14 +276,13 @@ static struct crypto_comp * __percpu *ipcomp_alloc_tfms(const char *alg_name)
 	struct crypto_comp * __percpu *tfms;
 	int cpu;
 
-	/* This can be any valid CPU ID so we don't need locking. */
-	cpu = raw_smp_processor_id();
-
 	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+
+		/* This can be any valid CPU ID so we don't need locking. */
+		tfm = __this_cpu_read(tfms);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
-- 
1.7.1

