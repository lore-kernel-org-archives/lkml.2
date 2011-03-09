Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1CIGer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:34:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34134 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1CIGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:34:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qiGzBbq2gFK3q8GhpHyNvaRu/WScd2DYHFQq0UIFcABo+iVwPiZ+DNUt+4Pn1i3EIx
         n5PFSZ8K5R8t1tX7Uvp9HS9pdoPYjb5Rm4v8jmsM42+AI8i0o1jPGA5IneOgWp43fPeN
         dXJkUa8Suf/AkVNyeVl0LgMqGkg2ifY3GA308=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] vmalloc: remove confusing comment on vwrite()
Date: Wed,  9 Mar 2011 15:34:36 +0900
Message-Id: <1299652476-5185-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KM_USER1 is never used for vwrite() path so the caller
doesn't need to guarantee it is not used. Only the caller
should guarantee is KM_USER0 and it is commented already.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/vmalloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f9b166732e70..2828b6122bd4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1951,8 +1951,6 @@ finished:
  *	should know vmalloc() area is valid and can use memcpy().
  *	This is for routines which have to access vmalloc area without
  *	any informaion, as /dev/kmem.
- *
- *	The caller should guarantee KM_USER1 is not used.
  */
 
 long vwrite(char *buf, char *addr, unsigned long count)
-- 
1.7.4

