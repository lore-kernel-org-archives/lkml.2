Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2JNOlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:41:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46021 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab2JNOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:41:29 -0400
Message-Id: <20121014143534.611461916@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:35:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Kozina <skozina@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 006/147] Remove BUG_ON from n_tty_read()
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kozina <skozina@redhat.com>

commit e9490e93c1978b6669f3e993caa3189be13ce459 upstream.

Change the BUG_ON to WARN_ON and return in case of tty->read_buf==NULL. We want to track a
couple of long standing reports of this but at the same time we can avoid killing the box.

Signed-off-by: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/n_tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 6259242..8c0b7b4 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1742,7 +1742,8 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 do_it_again:
 
-	BUG_ON(!tty->read_buf);
+	if (WARN_ON(!tty->read_buf))
+		return -EAGAIN;
 
 	c = job_control(tty, file);
 	if (c < 0)


