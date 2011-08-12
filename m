Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1HLAY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:24:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51690 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753563Ab1HLAYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:24:25 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1+EcMhNjeqERIJJ4GP7s5VJgA4owRxHsoqRXTkW3X
	vLJK+ykNNPWJxl
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] um: drivers/xterm.c: fix a file descriptor leak
Date: Fri, 12 Aug 2011 02:24:10 +0200
Message-Id: <1313108650-5941-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could use out_close1, but that seems to be the code path to close the
fd returned by os_create_unix_socket, and using it to close the fd
returned by mkstemp might lead to some confusion, so I don't do it.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 arch/um/drivers/xterm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/drivers/xterm.c b/arch/um/drivers/xterm.c
index 8ac7146..2e1de57 100644
--- a/arch/um/drivers/xterm.c
+++ b/arch/um/drivers/xterm.c
@@ -123,6 +123,7 @@ static int xterm_open(int input, int output, int primary, void *d,
 		err = -errno;
 		printk(UM_KERN_ERR "xterm_open : unlink failed, errno = %d\n",
 		       errno);
+		close(fd);
 		return err;
 	}
 	close(fd);
-- 
1.7.5.4

