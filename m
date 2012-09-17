Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2IQBWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:22:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263Ab2IQAuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:00 -0400
Message-Id: <20120917003644.845411777@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0=20=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F?= 
	<olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 135/135] vfs: make O_PATH file descriptors usable for fstat()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 55815f70147dcfa3ead5738fd56d3574e2e3c1c2 upstream.

We already use them for openat() and friends, but fstat() also wants to
be able to use O_PATH file descriptors.  This should make it more
directly comparable to the O_SEARCH of Solaris.

Note that you could already do the same thing with "fstatat()" and an
empty path, but just doing "fstat()" directly is simpler and faster, so
there is no reason not to just allow it directly.

See also commit 332a2e1244bd, which did the same thing for fchdir, for
the same reasons.

Reported-by: ольга крыжановская <olga.kryzhanovska@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index b6ff118..4078022 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(vfs_getattr);
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	int fput_needed;
-	struct file *f = fget_light(fd, &fput_needed);
+	struct file *f = fget_raw_light(fd, &fput_needed);
 	int error = -EBADF;
 
 	if (f) {


