Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0IIOPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:15:01 -0400
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:40665 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754450Ab0IIOO6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:14:58 -0400
Subject: [PATCH] perf: Fix compilation warning/abort
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: a.p.zijlstra@chello.nl, acme@redhat.com, mingo@elte.hu
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 10:14:47 -0400
Message-ID: <1284041687.2000.6.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] perf: Fix compilation warning regarding the -Wstack-protector option.

The message is (GCC 4.4.3):

CC util/ui/util.o
cc1: warnings being treated as errors
util/ui/util.c: In function ‘ui__dialog_yesno’:
util/ui/util.c:109: error: not protecting function: no buffer at least 8 bytes long
make: *** [util/ui/util.o] Error 1

This was also mentioned in http://lkml.org/lkml/2010/8/21/143

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 tools/perf/util/ui/util.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 04600e2..e5b1186 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -109,6 +109,5 @@ out_destroy_form:
 bool ui__dialog_yesno(const char *msg)
 {
 	/* newtWinChoice should really be accepting const char pointers... */
-	char yes[] = "Yes", no[] = "No";
-	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
+	return newtWinChoice(NULL, (char *) "Yes", (char *) "No", (char *)msg) == 1;
 }
-- 
1.7.0.4



