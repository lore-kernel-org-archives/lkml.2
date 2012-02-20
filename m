Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2BTCZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:25:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2BTCZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:25:52 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/7] compat: Handle COMPAT_USE_64BIT_TIME in the lp driver
Date: Sun, 19 Feb 2012 18:22:46 -0800
Message-Id: <1329704570-3792-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329704570-3792-1-git-send-email-hpa@zytor.com>
References: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
 <1329704570-3792-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 18:25:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Enable the lp driver to be used with a compat ABI with 64-bit time.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/char/lp.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..64f5aeb 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -706,16 +706,13 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
 {
 	unsigned int minor;
 	struct timeval par_timeout;
-	struct compat_timeval __user *tc;
 	int ret;
 
 	minor = iminor(file->f_path.dentry->d_inode);
 	mutex_lock(&lp_mutex);
 	switch (cmd) {
 	case LPSETTIMEOUT:
-		tc = compat_ptr(arg);
-		if (get_user(par_timeout.tv_sec, &tc->tv_sec) ||
-		    get_user(par_timeout.tv_usec, &tc->tv_usec)) {
+		if (compat_get_timeval(par_timeout, compat_ptr(arg))) {
 			ret = -EFAULT;
 			break;
 		}
-- 
1.7.6.5

