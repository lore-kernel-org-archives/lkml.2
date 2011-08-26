Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1HZUhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:37:09 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:46952 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1HZUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:37:06 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] powerpc/eeh: fix /proc/ppc64/eeh creation
Date: Fri, 26 Aug 2011 17:36:31 -0300
Message-Id: <1314390991-27223-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11082620-8936-0000-0000-000004451486
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 188917e183cf9ad0374b571006d0fc6d48a7f447, /proc/ppc64 is a
symlink to /proc/powerpc/. That means that creating /proc/ppc64/eeh will
end up with a unaccessible file, that is not listed under /proc/powerpc/
and, then, not listed under /proc/ppc64/.

Creating /proc/powerpc/eeh fixes that problem and maintain the
compatibility intended with the ppc64 symlink.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index ada6e07..d42f37d 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1338,7 +1338,7 @@ static const struct file_operations proc_eeh_operations = {
 static int __init eeh_init_proc(void)
 {
 	if (machine_is(pseries))
-		proc_create("ppc64/eeh", 0, NULL, &proc_eeh_operations);
+		proc_create("powerpc/eeh", 0, NULL, &proc_eeh_operations);
 	return 0;
 }
 __initcall(eeh_init_proc);
-- 
1.7.4.4

