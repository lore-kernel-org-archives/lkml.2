Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1FISXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:23:40 -0400
Received: from mail.perches.com ([173.55.12.10]:2698 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1FISXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:23:38 -0400
Subject: [PATCH] vsprintf: Update %pI6c to not compress a single 0
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Murray <amurray@mpcdata.com>
In-Reply-To: <1307642692-23556-1-git-send-email-amurray@mpcdata.com>
References: <BANLkTik14_Zbfb3e9FXx_yUs35kBh6FqFg@mail.gmail.com>
	 <1307642692-23556-1-git-send-email-amurray@mpcdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 11:23:37 -0700
Message-ID: <1307643817.13329.32.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC 5952 http://tools.ietf.org/html/rfc5952
mandates that 2 or more consecutive 0's are
required before using :: compression.

Update ip6_compressed_string to match the RFC and
update the http reference as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c112056..4365df3 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -666,6 +666,8 @@ char *ip6_compressed_string(char *p, const char *addr)
 			colonpos = i;
 		}
 	}
+	if (longest == 1)		/* don't compress a single 0 */
+		colonpos = -1;
 
 	/* emit address */
 	for (i = 0; i < range; i++) {
@@ -826,7 +828,7 @@ int kptr_restrict __read_mostly;
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
  * - '[Ii]4[hnbl]' IPv4 addresses in host, network, big or little endian order
  * - 'I6c' for IPv6 addresses printed as specified by
- *       http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
+ *       http://tools.ietf.org/html/rfc5952
  * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
  *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  *       Options for %pU are:
-- 
1.7.6.rc0



