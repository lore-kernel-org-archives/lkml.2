Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab2J2UIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:08:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:42522 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585Ab2J2UIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:08:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>, David Miller <davem@davemloft.net>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 02/34] fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check
Date: Mon, 29 Oct 2012 13:07:33 -0700
Message-Id: <20121029200420.851856769@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 12176503366885edd542389eed3aaf94be163fdb upstream.

The compat ioctl for VIDEO_SET_SPU_PALETTE was missing an error check
while converting ioctl arguments.  This could lead to leaking kernel
stack contents into userspace.

Patch extracted from existing fix in grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -208,6 +208,8 @@ static int do_video_set_spu_palette(unsi
 
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
+	if (err)
+		return -EFAULT;
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
 	err  = put_user(compat_ptr(palp), &up_native->palette);


