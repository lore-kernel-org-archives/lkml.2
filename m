Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1IGWfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:35:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1IGWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:35:13 -0400
Message-ID: <4E67F1AE.90204@gmail.com>
Date: Thu, 08 Sep 2011 01:35:26 +0300
From: kordex@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] mm/cleancache.c __init init_cleancache(void) incorrect
 return value.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most likely solution bellow should be applied.

Br,
Mikko Kortelainen
Fail-Safe IT Solutions Oy

lain:/usr/src# diff -Naur a/mm/cleancache.c b/mm/cleancache.c
--- a/mm/cleancache.c   2011-08-29 23:56:30.000000000 +0300
+++ b/mm/cleancache.c   2011-09-08 01:24:15.000000000 +0300
@@ -234,11 +234,10 @@

  static int __init init_cleancache(void)
  {
+       int err = 0;
  #ifdef CONFIG_SYSFS
-       int err;
-
         err = sysfs_create_group(mm_kobj, &cleancache_attr_group);
  #endif /* CONFIG_SYSFS */
-       return 0;
+       return err;
  }
  module_init(init_cleancache)

