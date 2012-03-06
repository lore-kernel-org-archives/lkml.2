Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586Ab2CFMkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:40:51 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40053 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2CFMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:40:49 -0500
Date: Tue, 6 Mar 2012 13:40:42 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 regression fix for 3.3-rc6
Message-ID: <20120306134042.337a6fc6@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12030612-8372-0000-0000-000001E928CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Steffen Maier (1):
      [S390] qdio: fix handler function arguments for zfcp data router

It is a fix for a regression that has been introduced with git commit
25f269f17316549e and if possible we would like to have working code
for the fcp data router in 3.3.

 drivers/s390/cio/qdio_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 3ef8d07..770a740 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -167,7 +167,7 @@ again:
 	DBF_ERROR("%4x EQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-		   0, -1, -1, q->irq_ptr->int_parm);
+		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
 
@@ -215,7 +215,7 @@ again:
 	DBF_ERROR("%4x SQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-		   0, -1, -1, q->irq_ptr->int_parm);
+		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
 

