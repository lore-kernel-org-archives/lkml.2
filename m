Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031797Ab2I1UC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:02:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab2I1Sze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0=20=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F?= 
	<olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: =?UTF-8?q?=5B=20038/262=5D=20vfs=3A=20make=20O=5FPATH=20file=20descriptors=20usable=20for=20fstat=28=29?=
Date: Fri, 28 Sep 2012 11:49:27 -0700
Message-Id: <20120928183002.423126663@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(vfs_getattr);
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
 	int fput_needed;
-	struct file *f = fget_light(fd, &fput_needed);
+	struct file *f = fget_raw_light(fd, &fput_needed);
 	int error = -EBADF;
 
 	if (f) {


