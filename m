Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab0KTFGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 00:06:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0KTFGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 00:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=dg50XiT2iL9vsvwWZSJlZwxx5XlIOMNkK4+Cd0/NlJg//Gql9KmmSrp7TuBlGfDIxz
         BnewcSTBgQWVJqnmk0JKnRdiw9SuQLH80aobfII5PmxuFq1CGh4sbMB4/D9kPOOh25VS
         mxbTjPeJs1VSywpANG5lyqeLJIzHnbWPt4I0w=
Subject: [PATCH] Shrink fanotify_event_metadata by 32 bits
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 20 Nov 2010 05:08:22 +0000
Message-ID: <20101120050353.32269.90666.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be no point wasting 32 bits for either the event version or length

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---

Hi.

While I'm working on the file modification events,
please consider this patch. It obviously breaks
the userspace ABI. But maybe that's acceptable, given
that no kernel has ever been released with the old ABI.

And the users only need to recompile their code, without
changing anything.

If we agree that this change is desirable, please make sure
it makes it to Linus before the release. ;)


 include/linux/fanotify.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 0f01214..9a7986f 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -86,10 +86,11 @@
 #define FANOTIFY_METADATA_VERSION	2
 
 struct fanotify_event_metadata {
-	__u32 event_len;
-	__u32 vers;
-	__aligned_u64 mask;
+	__u16 event_len;
+	__u8 vers;
+	__u8 reserved;
 	__s32 fd;
+	__aligned_u64 mask;
 	__s32 pid;
 };
 

