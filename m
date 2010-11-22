Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0KVAbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:31:35 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50626 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab0KVAbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=jgwPM429gMvSKmP9DxlsMzubyJwiLDzVY+VqrMCoqYUO+Zwyv28nT8aO/T7Lz0vyRo
         AEjKuPeuOWcdmx07PjU6fN9vC6lAY/PAatagVHadSVSz5sP9mI2cVJ1XSQWwJDVdwbbT
         jxcOzSStEi1eox3SRJStGR0niJu71N4zvecps=
Subject: [PATCH 1/4] fanotify: Shrink struct fanotify_event_metadata by 32
 bits
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Mon, 22 Nov 2010 00:33:03 +0000
Message-ID: <20101122003157.13674.42596.stgit@zaytsev.su>
In-Reply-To: <20101122002747.13674.69384.stgit@zaytsev.su>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And this saves additional 32 bits in the future

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
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
 

