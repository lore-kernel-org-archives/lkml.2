Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1KPTds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:33:48 -0500
Received: from smtp-out-060.synserver.de ([212.40.185.60]:1136 "HELO
	smtp-out-058.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751907Ab1KPTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:33:47 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16707
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/2] regmap: Drop check whether a register is readable in regcache_read
Date: Wed, 16 Nov 2011 20:34:04 +0100
Message-Id: <1321472044-15686-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321472044-15686-1-git-send-email-lars@metafoo.de>
References: <1321472044-15686-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the reasons for using a cache is to have a software shadow of a register
which is writable but not readable. This allows us to do a read-modify-write
operation on such a register.

Currently regcache checks whether a register is readable when performing a
cached read and returns an error if it is not. Drop this check, since it will
prevent us from using the cache for registers where read-back is not possible.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Drop the check instead of replaceing it with a check whether the register
	  is writable since this would break once we start adding read-back values
	  to the cache.
---
 drivers/base/regmap/regcache.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6d93e49..e21eebd 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -199,9 +199,6 @@ int regcache_read(struct regmap *map,
 
 	BUG_ON(!map->cache_ops);
 
-	if (!regmap_readable(map, reg))
-		return -EIO;
-
 	if (!regmap_volatile(map, reg))
 		return map->cache_ops->read(map, reg, value);
 
-- 
1.7.7.1

