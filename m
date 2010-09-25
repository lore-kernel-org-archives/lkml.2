Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0IYTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:20:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33462 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0IYTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=vejG9YQPdMTjtQuzWhEAA8EVu2Xz+eUVeULCmrzS5kSXy9Yi2GFWE9FcVxYlN6KLdI
         IHuG7DBxvPmyhsDf7XwACmEAeext9dQKQRYR9mUc5MtS4phVsoD/R+BQwQxpJxG5hLWU
         Jitqbf6orEDUm292eqr7XgGG+5WCnsaIaBzPk=
MIME-Version: 1.0
From: Dragos Tatulea <dragos.tatulea@gmail.com>
Date: Sat, 25 Sep 2010 21:20:05 +0200
Message-ID: <AANLkTi=F2aRd1Edq0+QgwF5+J9So-RVYeUB5qcK5WzRd@mail.gmail.com>
Subject: [PATCH] Fix oprofile -Werror compile failure encountered while doing
 a MIPS Malta build.
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dragos Tatulea <dragos.tatulea@gmail.com>
---
 drivers/oprofile/buffer_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index b7e755f..a832644 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -500,7 +500,7 @@ void sync_buffer(int cpu)
 {
        struct mm_struct *mm = NULL;
        struct mm_struct *oldmm;
-       unsigned long val;
+       unsigned long uninitialized_var(val);
        struct task_struct *new;
        unsigned long cookie = 0;
        int in_kernel = 1;
-- 
1.7.2.3
