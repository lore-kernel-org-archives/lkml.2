Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965719Ab2EOCbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:31:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53541 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965286Ab2EOCSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 155/179] powerpc: pseries: Fix kexec on machines with more than 4TB of RAM
Date: Mon, 14 May 2012 22:14:11 -0400
Message-ID: <1337048075-6132-156-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bed9a31527af8ff3dfbad62a1a42815cef4baab7 upstream.

On a box with 8TB of RAM the MMU hashtable is 64GB in size. That
means we have 4G PTEs. pSeries_lpar_hptab_clear was using a signed
int to store the index which will overflow at 2G.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/platforms/pseries/lpar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index cf79b46..7e0eba4 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -372,7 +372,7 @@ static void pSeries_lpar_hptab_clear(void)
 		unsigned long ptel;
 	} ptes[4];
 	long lpar_rc;
-	int i, j;
+	unsigned long i, j;
 
 	/* Read in batches of 4,
 	 * invalidate only valid entries not in the VRMA
-- 
1.7.9.6

