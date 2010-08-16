Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0HPISi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:18:38 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:46789 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0HPISh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:18:37 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org
Subject: [PATCH] alpha: Fix compile error due to typo in call of do_osf_statfs()
Date: Mon, 16 Aug 2010 20:18:00 +1200
Message-Id: <1281946680-23497-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.1
X-DSPAM-Check: by mx6.orcon.net.nz on Mon, 16 Aug 2010 20:18:34 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Aug 16 20:18:34 2010
X-DSPAM-Confidence: 0.9928
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo, i.e., missing comma in argument list of call of do_osf_statfs(),
was introduced by commit ebabe9a9001af0af56c0c2780ca1576246e7a74b.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/kernel/osf_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index fb58150..5d1e6d6 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -252,7 +252,7 @@ SYSCALL_DEFINE3(osf_statfs, const char __user *, pathname,
 
 	retval = user_path(pathname, &path);
 	if (!retval) {
-		retval = do_osf_statfs(&path buffer, bufsiz);
+		retval = do_osf_statfs(&path, buffer, bufsiz);
 		path_put(&path);
 	}
 	return retval;
-- 
1.7.1

