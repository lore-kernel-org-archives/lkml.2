Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2LYQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:01:07 -0500
Received: from re04.intra2net.com ([82.165.46.26]:49285 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LYQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:01:06 -0500
X-Greylist: delayed 1274 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 11:01:06 EST
Message-ID: <50D9C8C2.2000801@intra2net.com>
Date: Tue, 25 Dec 2012 16:39:46 +0100
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [perf PATCH] Fix possible double free on error
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can only be triggered via CROSS_COMPILE env var.
Detected by cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/arch/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 3e975cb..aacef07 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -155,6 +155,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		if (lookup_path(buf))
 			goto out;
 		free(buf);
+		buf = NULL;
 	}
 
 	if (!strcmp(arch, "arm"))
-- 
1.7.11.7

