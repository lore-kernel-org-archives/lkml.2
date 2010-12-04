Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0LEKyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 05:54:09 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63373 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0LEKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 05:54:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NW4zcMrrWHYtSdb2+Fz8M5PTepUVdT1uO20g0MCqHWXmqEdqLPqu8+pNyWUVRE8cxi
         XStnuPgwSFp9bkLXH492T1eezJ2dlNtTs2ElskXU/3NFkvBlaT53mXx5od8qnW1TH29W
         O241QF0Dmpdu7PY9jB+6KDNkh4dAuAg84xEpc=
From: bookjovi@gmail.com
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Jovi Zhang <bookjovi@gmail.com>
Subject: [PATCH] perf_event: fix error handling path
Date: Fri,  3 Dec 2010 22:19:12 -0500
Message-Id: <1291432752-2466-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix error handling path

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
 kernel/perf_event.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index cb6c0d2..62f9e9d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1918,8 +1918,6 @@ static int get_callchain_buffers(void)
 	}
 
 	err = alloc_callchain_buffers();
-	if (err)
-		release_callchain_buffers();
 exit:
 	mutex_unlock(&callchain_mutex);
 
