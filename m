Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab2KTQ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:29:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60931 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2KTQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:29:16 -0500
Subject: [PATCH] sendfile: allows bypassing of notifier events
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 20 Nov 2012 16:31:34 +0000
Message-ID: <20121120163133.11806.15152.stgit@bob.linux.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wolchok <swolchok@umich.edu>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=12812
---

 fs/read_write.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index d065348..1c7f101 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -935,6 +935,8 @@ ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
 	if (retval > 0) {
 		add_rchar(current, retval);
 		add_wchar(current, retval);
+		fsnotify_access(in.file);
+		fsnotify_access(out.file);
 	}
 
 	inc_syscr(current);

