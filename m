Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2DNQC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:02:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44703 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab2DNQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:02:24 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] mm: fixup compilation error due to an asm write through a const pointer
Date: Sat, 14 Apr 2012 18:03:10 +0200
Message-Id: <1334419390-18961-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <CAMuHMdXBEiDGyJQ+szoBKxo0pS=n3xKfpb=F+rNkMQUv4SdTQA@mail.gmail.com>
References: <CAMuHMdXBEiDGyJQ+szoBKxo0pS=n3xKfpb=F+rNkMQUv4SdTQA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This regression has been introduced in

commit f56f821feb7b36223f309e0ec05986bb137ce418
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun Mar 25 19:47:41 2012 +0200

    mm: extend prefault helpers to fault in more than PAGE_SIZE

I have failed to notice this because x86 asm seems to happily compile
things as-is.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/linux/pagemap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c93a9a9..efa26b4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -461,7 +461,7 @@ static inline int fault_in_pages_readable(const char __user *uaddr, int size)
 static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
 {
 	int ret;
-	const char __user *end = uaddr + size - 1;
+	char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
 		return 0;
-- 
1.7.10

