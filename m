Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0IKApt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:45:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45235 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0IKApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=faKLM8VlpQGRW+vCYD+MtM/ahZf7DrIiXB5OKMsDUjpFlW4NNsrGfdhv3G2Kbwpaos
         pr7BYlDBjh8WDRr2dlJ18/E6ESzJES/ydy3LtYaWFODXBJZL7CGO33B9bjHrbi4f5Ps6
         KpK3cE/Xdin7WMgf8THrJVmbqAdRfcESX6QvQ=
Subject: [PATCH] FS: cifs: Fix compile warning
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Steve French <sfrench@samba.org>, Jeff Layton <jlayton@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 20:45:42 -0400
Message-ID: <1284165942.4009.5.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In today linux-next I got a compile warning due a possibly uninitialized variable

This trivial patch solves the issue

Thanks a lot

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..ee1bba4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		__u32 parm_len;
 		__u32 acl_len;
 		struct smb_com_ntransact_rsp *pSMBr;
-		char *pdata;
+		char *pdata = NULL;
 
 /* validate_nttransact */
 		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
-- 
1.7.0.4




