Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0GHM5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:57:47 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64686 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab0GHM5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:57:45 -0400
To: arnd@arndb.de, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 18/18] vfs: make no_llseek the default
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
	<1278538820-1392-19-git-send-email-arnd@arndb.de>
	<201007082025.HDB82385.OOVHQSLtFFMFJO@I-love.SAKURA.ne.jp>
	<201007081408.06415.arnd@arndb.de>
In-Reply-To: <201007081408.06415.arnd@arndb.de>
Message-Id: <201007082157.IFC26590.JMQSHOFFFOVLtO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 8 Jul 2010 21:57:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> The behaviour you want is noop_llseek, which is what gets used
> when the semantic patch is applied. If you wish, you can
> do the patch yourself and add .llseek = noop_llseek to the file
> operations in your tree.

I see. [PATCH 16/18] ( http://lkml.org/lkml/2010/7/7/258 ) contains a line

   security/tomoyo/common.c                      |    1 +

but no change in the patch. Patch was too large?
Anyway, that part is no longer in security/tomoyo/common.c
and is now security/tomoyo/securityfs_if.c .
James, please apply below patch.
----------
>From d0fdb09cdc8ef46151d330a9fc285de86306fa65 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 8 Jul 2010 21:38:05 +0900
Subject: [PATCH] TOMOYO: Explicitly set file_operations->llseek pointer.

TOMOYO does not deal offset pointer. Thus seek operation makes
no sense. Changing default seek operation from default_llseek()
to no_llseek() might break some applications. Thus, explicitly
set noop_llseek().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/securityfs_if.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/tomoyo/securityfs_if.c b/security/tomoyo/securityfs_if.c
index 9967c1c..e43d555 100644
--- a/security/tomoyo/securityfs_if.c
+++ b/security/tomoyo/securityfs_if.c
@@ -95,6 +95,7 @@ static const struct file_operations tomoyo_operations = {
 	.poll    = tomoyo_poll,
 	.read    = tomoyo_read,
 	.write   = tomoyo_write,
+	.llseek  = noop_llseek,
 };
 
 /**
-- 
1.6.1
