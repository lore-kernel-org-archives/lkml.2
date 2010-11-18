Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0KRKvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:51:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42155 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab0KRKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:51:08 -0500
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] perf: Handle perf-versionnumber
Date: Thu, 18 Nov 2010 11:51:01 +0100
Message-Id: <1290077461-12321-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Sometimes it's useful to have multiple perfs with version number
around. This was defeated by the internal command code. Don't
try to handle a number as a internal command.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/perf.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cdd6c03..c14c0fa 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -444,8 +444,11 @@ int main(int argc, const char **argv)
 	 *
 	 * So we just directly call the internal command handler, and
 	 * die if that one cannot handle it.
+ 	 *
+ 	 * If there is a number after the - don't do this. Assume it's
+	 * a perf-VERSIONNUMBER
 	 */
-	if (!prefixcmp(cmd, "perf-")) {
+	if (!prefixcmp(cmd, "perf-") && !isdigit(cmd[5])) {
 		cmd += 5;
 		argv[0] = cmd;
 		handle_internal_command(argc, argv);
-- 
1.7.1

