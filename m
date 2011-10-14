Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab1JNR2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:28:51 -0400
Received: from re04.intra2net.com ([82.165.46.26]:47327 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab1JNR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:28:50 -0400
Message-ID: <4E986ABF.9040706@intra2net.com>
Date: Fri, 14 Oct 2011 19:00:47 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org
Subject: [perf PATCH] Fix possible unterminated readlink() result buffer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to do "buf[len] = '\0';" since the buffer
is allocated with zalloc().

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b6c1ad1..1a1c026 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -267,7 +267,7 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 	if (access(linkname, F_OK))
 		goto out_free;
 
-	if (readlink(linkname, filename, size) < 0)
+	if (readlink(linkname, filename, size-1) < 0)
 		goto out_free;
 
 	if (unlink(linkname))
-- 
1.7.6.4

