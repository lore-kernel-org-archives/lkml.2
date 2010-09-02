Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0IBSH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:07:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46217 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0IBSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=E25VigLGt59/yCiTQT2FhGc+swK2X4AEVzxoLFGXrn2M3tHsxKtDnpNX0ePqjod3nv
         HeJE5d88h4sSfWq4n46weAOF4Zn8K6bRQJIGKBGbuYn0E8AZpVHuirxxWElJ25+18Sj/
         q3tKVXzT9LuVGuJii4jIvtB9ggtkfKh9lLj2w=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ida: fix up bitmap size calculation
References: <1283446829-24050-1-git-send-email-namhyung@gmail.com>
	<4C7FDCE4.1080703@kernel.org>
	<AANLkTi=Ema3mTkU7J7XKqmntA+VDJizhBuDHHnZtV_9K@mail.gmail.com>
Date: Fri, 03 Sep 2010 03:07:16 +0900
In-Reply-To: <AANLkTi=Ema3mTkU7J7XKqmntA+VDJizhBuDHHnZtV_9K@mail.gmail.com>
	(Namhyung Kim's message of "Fri, 3 Sep 2010 02:25:22 +0900")
Message-ID: <87vd6o9fzf.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:
> Got it. :-) I'll prepare new patch with that comment, then.
> Thank you for the explanation.

How about this?

>From 38866b19cdbf03d133c54a1f3b7d48279bdd4177 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@gmail.com>
Date: Fri, 3 Sep 2010 02:44:47 +0900
Subject: [PATCH] ida: document IDA_BITMAP_LONGS calculation

IDA_BITMAP_LONGS value is calculated take into account struct ida_bitmap
not to waste memory space. Comment it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/idr.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..7807e4b 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -119,9 +119,16 @@ void idr_init(struct idr *idp);
  * pointer isn't necessary.
  */
 #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
+/*
+ * -1 is needed here to fit total chunk size into 128 bytes because
+ * struct ida_bitmap consists of nr_busy and bitmap. Since it is
+ * allocated by kmalloc(), chunk size should be matched with kmalloc
+ * size so that it will not waste memory.
+ */
 #define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
-#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
+#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
 
+/* IDA bitmap chunk */
 struct ida_bitmap {
 	long			nr_busy;
 	unsigned long		bitmap[IDA_BITMAP_LONGS];
-- 
1.7.2.2

