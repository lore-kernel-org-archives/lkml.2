Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1CMQYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:24:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1CMQYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=XKcWa3txfb/AqmgmSrobITeVw8PWjQejAUkbYmRR3rriM+u39rI5m/evPQr6G9utky
         k3SSo0f0scN5Mirq+pBjdjPNbbvMxMeqp2pyxtaMFsemUafHwNtO3NdgHwsPydlZIwPZ
         VGaFD3nr/5hdFk+hewKKnxCpcuFgItE7CAppE=
From: Richard Genoud <richard.genoud@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] =?UTF-8?q?cifssmb:=20[FIX]=20warning:=20=E2=80=98pdata=E2=80=99=20may=20be=20used=20uninitialized?=
Date: Sun, 13 Mar 2011 17:23:46 +0100
Message-Id: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This suppress the warning, as far as there's no way pdata is
uninitialized, because validate_ntransact() will initialize pdata or
return rc != 0. In this case (goto qsec_out), pdata won't be used.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 904aa47..efa3f8e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3138,7 +3138,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		__u32 parm_len;
 		__u32 acl_len;
 		struct smb_com_ntransact_rsp *pSMBr;
-		char *pdata;
+		char *pdata = NULL;
 
 /* validate_nttransact */
 		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
-- 
1.7.1

