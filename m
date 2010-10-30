Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0J3OW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:22:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59896 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0J3OWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jrSemKmQVkeq7Tm5Ti2qrmp+SXkAXyPbI5cO2mzC/9YqCYNRF/61yImS2hmgCUZ2Md
         OrvtoMa+3XxyfPhGqYvpHcqqisMZT1fFSQYS1T5BXQkcjOeIkcf5RCECqYi9UKPFj2xg
         tjgr+nnbRoETpFm0iekLOBfY/uHyAI3K7dhzg=
Date: Sat, 30 Oct 2010 18:22:49 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>, David Howells <dhowells@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc: shm: fix information leak to userland
Message-ID: <20101030142249.GA9835@albatros>
References: <1288429477-21920-1-git-send-email-segooon@gmail.com>
 <20101030090644.GX19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101030090644.GX19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure shmid_ds is copied to userland with shm_unused{,2,3}
fields unitialized.  It leads to leaking of contents of kernel stack
memory.

Cc: stable@kernel.org
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 ipc/shm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index fd658a1..7d3bb22 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -479,6 +479,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
-- 
1.7.0.4
