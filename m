Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0DVTzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:55:07 -0400
Received: from kroah.org ([198.145.64.141]:40862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab0DVT2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:36 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:14 2010
Message-Id: <20100422190914.831868504@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <sfrench@us.ibm.com>
Subject: [083/197] CIFS: initialize nbytes at the beginning of CIFSSMBWrite()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit a24e2d7d8f512340991ef0a59cb5d08d491b8e98 upstream.

By doing this we always overwrite nbytes value that is being passed on to
CIFSSMBWrite() and need not rely on the callers to initialize. CIFSSMBWrite2 is
doing this already.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Reviewed-by: Jeff Layton <jlayton@samba.org>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifssmb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1430,6 +1430,8 @@ CIFSSMBWrite(const int xid, struct cifsT
 	__u32 bytes_sent;
 	__u16 byte_count;
 
+	*nbytes = 0;
+
 	/* cFYI(1, ("write at %lld %d bytes", offset, count));*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
@@ -1512,7 +1514,6 @@ CIFSSMBWrite(const int xid, struct cifsT
 	cifs_stats_inc(&tcon->num_writes);
 	if (rc) {
 		cFYI(1, ("Send error in write = %d", rc));
-		*nbytes = 0;
 	} else {
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;


