Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0E1Lkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:40:49 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:47242 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab0E1Lks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:40:48 -0400
Date: Fri, 28 May 2010 13:41:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] fs/compat_rw_copy_check_uvector: add missing compat_ptr
 call
Message-ID: <20100528114147.GB3686@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

A call to access_ok is missing a compat_ptr conversion. Introduced with
b83733639a494d5f42fa00a2506563fbd2d3015d "compat: factor out
compat_rw_copy_check_uvector from compat_do_readv_writev"

fs/compat.c: In function 'compat_rw_copy_check_uvector':
fs/compat.c:629: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
---

Probably should go into stable like the original patch.

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
