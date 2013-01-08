Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3AHXsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:48:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:63560 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3AHXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Federico Vaga <federico.vaga@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 32/77] Staging: comedi: fix signal handling in read and write
Date: Tue, 8 Jan 2013 18:35:11 -0500
Message-ID: <1357688156-25387-33-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Vaga <federico.vaga@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6a9ce6b654e491981f6ef7e214cbd4f63e033848 upstream.

After sleeping on a wait queue, signal_pending(current) should be
checked (not before sleeping).

Acked-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/comedi/comedi_fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 48ac52b..f6a0e76 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1594,11 +1594,11 @@ static ssize_t comedi_write(struct file *file, const char *buf, size_t nbytes,
 				retval = -EAGAIN;
 				break;
 			}
+			schedule();
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
 				break;
 			}
-			schedule();
 			if (!s->busy)
 				break;
 			if (s->busy != file) {
@@ -1701,11 +1701,11 @@ static ssize_t comedi_read(struct file *file, char *buf, size_t nbytes,
 				retval = -EAGAIN;
 				break;
 			}
+			schedule();
 			if (signal_pending(current)) {
 				retval = -ERESTARTSYS;
 				break;
 			}
-			schedule();
 			if (!s->busy) {
 				retval = 0;
 				break;
-- 
1.7.12.1

