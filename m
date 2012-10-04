Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946397Ab2JDVfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:35:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39431 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946359Ab2JDV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:27:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislav Kozina <skozina@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [ 11/33] Remove BUG_ON from n_tty_read()
Date: Thu,  4 Oct 2012 14:26:33 -0700
Message-Id: <20121004210559.881840515@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210558.383865383@linuxfoundation.org>
References: <20121004210558.383865383@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kozina <skozina@redhat.com>

commit e9490e93c1978b6669f3e993caa3189be13ce459 upstream.

Change the BUG_ON to WARN_ON and return in case of tty->read_buf==NULL. We want to track a
couple of long standing reports of this but at the same time we can avoid killing the box.

Signed-off-by: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1728,7 +1728,8 @@ static ssize_t n_tty_read(struct tty_str
 
 do_it_again:
 
-	BUG_ON(!tty->read_buf);
+	if (WARN_ON(!tty->read_buf))
+		return -EAGAIN;
 
 	c = job_control(tty, file);
 	if (c < 0)


