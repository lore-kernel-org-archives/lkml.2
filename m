Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0GEIBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:01:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0GEIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=KDzXTDxWcjELdc5l8cfA9bZRql3fn49B1YpRx/zNsc5PjfGcUQjzyMJYVoas5IJhVM
         dapQHzxBpOA+VUVLfMdtgTbS+aspULlp2IZM1PmqLxrd/2z/inBBiukX2ch9c0un1ooR
         wPrdQ+xsUX9v1F3+01RzbORdf1HkO+ASWmJg4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Steve French <sfrench@samba.org>, Jeff Layton <jlayton@redhat.com>,
       Suresh Jayaraman <sjayaraman@suse.de>, linux-cifs@vger.kernel.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: silence compiler warning
Date: Mon,  5 Jul 2010 12:01:09 +0400
Message-Id: <1278316870-29112-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If buf is NULL then ppdata is unitialized after exit from validate_ntransact().
In this case we do not use ppdata, but compiler warns us. Make it happy.

This patch silences a compiler warning:
fs/cifs/cifssmb.c: In function ‘CIFSSMBGetCIFSACL’:
fs/cifs/cifssmb.c:3082: warning: ‘pdata’ may be used uninitialized in this function

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 fs/cifs/cifssmb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..22805e2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2506,6 +2506,7 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 
 	*pdatalen = 0;
 	*pparmlen = 0;
+	*ppdata = 0;
 
 	if (buf == NULL)
 		return -EINVAL;
-- 
1.7.0.4

