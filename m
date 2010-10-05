Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0JEIsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:48:21 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54912 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab0JEIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:48:18 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, hsweeten@visionengravers.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 1/1] initramfs: strcpy destination string overflow
Date: Tue,  5 Oct 2010 12:44:17 +0400
Message-Id: <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-OriginalArrivalTime: 05 Oct 2010 08:47:51.0896 (UTC) FILETIME=[FEC68D80:01CB6469]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>

Function "strcpy()" is used without check for maximum allowed
source string length and could cause destination string overflow.
"strcpy()" is replaced by "strlcpy()" to prevent destination
string overflow.

Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
---
 init/initramfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 4b9c202..3e68568 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -56,7 +56,7 @@ static char __init *find_link(int major, int minor, int ino,
 	q->minor = minor;
 	q->ino = ino;
 	q->mode = mode;
-	strcpy(q->name, name);
+	strlcpy(q->name, name, sizeof(q->name));
 	q->next = NULL;
 	*p = q;
 	return NULL;
-- 
1.6.3.3

