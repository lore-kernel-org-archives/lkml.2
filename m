Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2F2U7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:59:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab2F2U7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:59:15 -0400
Date: Sat, 30 Jun 2012 02:29:02 +0530
From: Rabin Vincent <rabin@rab.in>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: CONFIG_HAVE_MEMBLOCK_NODE ->
 CONFIG_HAVE_MEMBLOCK_NODE_MAP
Message-ID: <20120629205902.GA12711@latitude>
References: <1341000877-12068-1-git-send-email-rabin@rab.in>
 <20120629202139.GD21048@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120629202139.GD21048@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:21:39PM -0700, Tejun Heo wrote:
> This probably has been doing something weird to 32bit machines w/
> memory hotplug configured (which probably are extremely rare).  It
> would be nice if the patch description explained what behavior it
> actually fixes.  How did you find this?  From config check util or did
> you actually see something broken?

Neither, I just noticed it while debugging some unrelated problems.  The
arch I work on (ARM) doesn't even select this so I don't have any
observed behaviour to describe -- I'll just add a paraphrase of your
statement about who's affected to the patch description.

8<--------------------
>From 38c7a50331efa83e4d07cbd1d6364d62e4448482 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 30 Jun 2012 01:17:45 +0530
Subject: [PATCHv2] mm: CONFIG_HAVE_MEMBLOCK_NODE -> CONFIG_HAVE_MEMBLOCK_NODE_MAP

0ee332c14518699 ("memblock: Kill early_node_map[]") wanted to replace
CONFIG_ARCH_POPULATES_NODE_MAP with CONFIG_HAVE_MEMBLOCK_NODE_MAP but
ended up replacing one occurence with a reference to the non-existent
symbol CONFIG_HAVE_MEMBLOCK_NODE.

The resulting omission of code would probably have been causing problems
to 32-bit machines with memory hotplug.

Cc: stable@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2427706..1d0a9a3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -773,7 +773,7 @@ extern int movable_zone;
 
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE)
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
-- 
1.7.9.5

