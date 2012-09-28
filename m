Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032056Ab2I1UX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:23:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032037Ab2I1UXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0=20=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F?= 
	<olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: =?UTF-8?q?=5B=20035/218=5D=20vfs=3A=20make=20O=5FPATH=20file=20descriptors=20usable=20for=20fstat=28=29?=
Date: Fri, 28 Sep 2012 13:14:12 -0700
Message-Id: <20120928201505.430974605@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct file *f = fget(fd);
+	struct file *f = fget_raw(fd);
 	int error = -EBADF;
 
 	if (f) {


