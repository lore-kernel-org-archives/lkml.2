Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab2EEBvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:51:44 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:39797 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab2EEBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:51:42 -0400
From: Adarsh J <root@hackmaster.in>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adarsh J <root@hackmaster.in>
Subject: [PATCH 1/1] lib/mpi: Fixed erroneous check on return value of mpi_resize()
Date: Sat,  5 May 2012 07:21:07 +0530
Message-Id: <1336182667-9784-1-git-send-email-root@hackmaster.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpi_resize() returns -ENOMEM on error and 0 on success.

Signed-off-by: Adarsh J <root@hackmaster.in>
---
 lib/mpi/mpicoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index f26b41f..9949b69 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -98,7 +98,7 @@ int mpi_fromstr(MPI val, const char *str)
 	nbytes = (nbits + 7) / 8;
 	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
 	if (val->alloced < nlimbs)
-		if (!mpi_resize(val, nlimbs))
+		if (mpi_resize(val, nlimbs) < 0)
 			return -ENOMEM;
 	i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
 	i %= BYTES_PER_MPI_LIMB;
-- 
1.7.9.5

