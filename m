Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1H2QQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:16:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:52389 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1H2QNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:13:50 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/9] um: drivers/xterm.c: fix a file descriptor leak
Date: Mon, 29 Aug 2011 18:13:32 +0200
Message-Id: <1314634419-24766-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314634419-24766-1-git-send-email-richard@nod.at>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

I could use out_close1, but that seems to be the code path to close the
fd returned by os_create_unix_socket, and using it to close the fd
returned by mkstemp might lead to some confusion, so I don't do it.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
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
1.7.6.1

