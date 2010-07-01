Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab0GAVRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:17:17 -0400
Received: from kroah.org ([198.145.64.141]:32926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759150Ab0GAVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:29 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.889898736@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [124/200] fs/compat_rw_copy_check_uvector: add missing compat_ptr call
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 7cbe17701a0379c7b05a79a6df4f24e41d2afde8 upstream.

A call to access_ok is missing a compat_ptr conversion.  Introduced with
b83733639a494d5f42fa00a2506563fbd2d3015d "compat: factor out
compat_rw_copy_check_uvector from compat_do_readv_writev"

fs/compat.c: In function 'compat_rw_copy_check_uvector':
fs/compat.c:629: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -626,7 +626,7 @@ ssize_t compat_rw_copy_check_uvector(int
 		tot_len += len;
 		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
 			goto out;
-		if (!access_ok(vrfy_dir(type), buf, len)) {
+		if (!access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
 		}


