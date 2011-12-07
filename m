Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1LGQSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:18:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab1LGQSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:18:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:26 2011
Message-Id: <20111207160826.547279908@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:08 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alessandro Rubini <rubini@gnudd.com>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [48/80] Staging: comedi: fix signal handling in read and write
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Vaga <federico.vaga@gmail.com>

commit 6a9ce6b654e491981f6ef7e214cbd4f63e033848 upstream.

After sleeping on a wait queue, signal_pending(current) should be
checked (not before sleeping).

Acked-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1673,11 +1673,11 @@ static ssize_t comedi_write(struct file
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
@@ -1780,11 +1780,11 @@ static ssize_t comedi_read(struct file *
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


