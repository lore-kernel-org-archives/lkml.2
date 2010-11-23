Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0KWOus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:50:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44703 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0KWOuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pT+VwuAmweK2Gaw2PV66m051tyrkUYjb1PM9eAzobWULtSIJvz3ybDwD497YP8FclU
         HWat4j7OFXEv31OeWRjM6ck/FckA7inUNUATKiBfyFqgyrzzpH7RxLZuVQ4vIZiSpC8w
         QnLByokV7XoJUDe4UqjkQl0sWqj9E6b1d+clc=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, rsync@lists.samba.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Ben Gamari <bgamari.foss@gmail.com>
Subject: [PATCH 2/3] Inform kernel of FADV_DONTNEED hint in sender
Date: Tue, 23 Nov 2010 09:49:51 -0500
Message-Id: <1290523792-6170-3-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101122103756.E236.A69D9226@jp.fujitsu.com>
References: <20101122103756.E236.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the FADV_DONTNEED fadvise hint after finishing reading an origin fd
in the sender.
---
 sender.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sender.c b/sender.c
index 59dae7d..a934bfe 100644
--- a/sender.c
+++ b/sender.c
@@ -338,6 +338,12 @@ void send_files(int f_in, int f_out)
 		if (do_progress)
 			end_progress(st.st_size);
 
+                if (do_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED) != 0) {
+                        rsyserr(FERROR_XFER, errno,
+                                "fadvise failed in sending %s",
+                                full_fname(fname));
+                }
+
 		log_item(log_code, file, &initial_stats, iflags, NULL);
 
 		if (mbuf) {
-- 
1.7.1

