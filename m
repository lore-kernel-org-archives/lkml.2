Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1HJIVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:21:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:50689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1HJIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:21:38 -0400
Content-Type: text/plain; charset=ANSI_X3.4-1968
Subject: kdev_t.h old major/minor numbers
From: Corey Richardson <kb1pkl@aim.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 04:21:15 -0400
Message-Id: <1312964160-sup-7942@hpsetup>
User-Agent: Sup/0.12.1
Content-Transfer-Encoding: 8bit
x-aol-global-disposition: G
X-AOL-SCOLL-SCORE: 0:2:357464512:93952408  
X-AOL-SCOLL-URL_COUNT: 0  
x-aol-sid: 3039ac1d33c44e423f8b7533
X-AOL-IP: 76.119.157.207
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Wed, 10 Aug 2011 08:21:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While reading through some of the kernel stuff I noticed that the macros
at the end of include/linux/kdev_t.h were out-of-sync with the macros at
the top. I'm not certain when/if they would ever be defined and not the
other ones (I'm very new to the kernel), but I would assume that they
shouldn't be using the old 255-number system.

Was this just an oversight or is there something else going on?

Patch:

--- linux/include/linux/kdev_t.h	2011-05-19 00:06:34.000000000 -0400
+++ git/include/linux/kdev_t.h.	2011-08-10 03:19:10.228987057 -0400
@@ -93,8 +93,11 @@
 Some programs want their definitions of MAJOR and MINOR and MKDEV
 from the kernel sources. These must be the externally visible ones.
 */
-#define MAJOR(dev)	((dev)>>8)
-#define MINOR(dev)	((dev) & 0xff)
-#define MKDEV(ma,mi)	((ma)<<8 | (mi))
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma,mi)	(((ma) << MINORBITS) | (mi))
 #endif /* __KERNEL__ */
 #endif
-- 
Corey Richardson
  "Those who deny freedom to others, deserve it not for themselves"
     -- Abraham Lincoln
