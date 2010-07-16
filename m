Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803Ab0GPPJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:09:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53516 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965754Ab0GPPJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ERf/SEjcRlMGuhStk5aLhiDXEkpFNCLHQozSEqb/rno5x1lM2pV4pHfs7/45rcf6vJ
         e9S5I8VNdZD5NwuODHjKgynGB6S3/mKQVBNyXhwQFBWxnBjoWAY354GzPqBdusGw4FTX
         wMjWG8yIwrTvSrvjdUxnMbr51H0L6pj3eeALw=
Message-ID: <4C407617.6080002@gmail.com>
Date: Fri, 16 Jul 2010 23:09:11 +0800
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: [PATCH] clear code: add macro wrapper for header mbcache.h
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In header file include/linux/mbcache.h, no macro wrapper defined.
I think it's better to add ifndef/define macro to wrap it.
Following patch is against 2.6.35-rc5. Please check it.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 include/linux/mbcache.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index a09b84e..3a6a802 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -3,6 +3,8 @@

   (C) 2001 by Andreas Gruenbacher, <a.gruenbacher@computer.org>
 */
+#ifndef __LINUX_MBCACHE_H
+#define __LINUX_MBCACHE_H

 /* Hardwire the number of additional indexes */
 #define MB_CACHE_INDEXES_COUNT 1
@@ -50,3 +52,5 @@ struct mb_cache_entry *mb_cache_entry_find_next(struct
mb_cache_entry *, int,
 						struct block_device *,
 						unsigned int);
 #endif
+
+#endif /* __LINUX_MBCACHE_H */
-- 
1.7.1.1


-- 
Thanks and Regards,
shenghui
