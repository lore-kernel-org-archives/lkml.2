Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1KUWQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:16:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40407 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1KUWQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:16:35 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: reset use_browser when compiled without NEWT
Date: Mon, 21 Nov 2011 15:16:28 -0700
Message-Id: <1321913788-2867-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e.g.,  when using
  make NO_NEWT=yes ...
or if newt-devel is not installed

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/cache.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index fc5e5a0..9d7612a 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -36,6 +36,7 @@ extern int use_browser;
 #ifdef NO_NEWT_SUPPORT
 static inline void setup_browser(bool fallback_to_pager)
 {
+	use_browser = 0;
 	if (fallback_to_pager)
 		setup_pager();
 }
-- 
1.7.7.1

