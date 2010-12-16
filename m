Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0LPJJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:09:35 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61132 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0LPJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GFjcdueTGMlBJRudqx8/6rjYQXIH7GrZ4l59dq0dTFIKFaiHAP68D4fKWAZcsV2DyM
         zVNcnTlVm7ztw89NWY/gO+Bf7PFrn29A3KOx8LhyvbbL57cKQktn/ZbvpwrwTpijjijD
         OR+mVd+9m9AQCAQDBTwmzXet4NXIp8zT1ideU=
From: Namhyung Kim <namhyung@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] aio: remove unnecessary check
Date: Thu, 16 Dec 2010 18:09:05 +0900
Message-Id: <1292490545-6071-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'nr >= min_nr >= 0' always satisfies 'nr >= 0' so the check is unnecesary.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c56153f5f73e..45766460fa57 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1839,7 +1839,7 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	long ret = -EINVAL;
 
 	if (likely(ioctx)) {
-		if (likely(min_nr <= nr && min_nr >= 0 && nr >= 0))
+		if (likely(min_nr <= nr && min_nr >= 0))
 			ret = read_events(ioctx, min_nr, nr, events, timeout);
 		put_ioctx(ioctx);
 	}
-- 
1.7.3.3.400.g93cef

