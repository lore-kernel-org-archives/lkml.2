Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1BPAjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:39:47 -0500
Received: from kroah.org ([198.145.64.141]:49486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab1BPAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.042135387@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steve French <sfrench@us.ibm.com>
Subject: [199/272] cifs: Fix regression during share-level security mounts (Repost)
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 540b2e377797d8715469d408b887baa9310c5f3e upstream.

NTLM response length was changed to 16 bytes instead of 24 bytes
that are sent in Tree Connection Request during share-level security
share mounts.  Revert it back to 24 bytes.

Reported-and-Tested-by: Grzegorz Ozanski <grzegorz.ozanski@intel.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Acked-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2999,7 +2999,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 		bcc_ptr++;              /* skip password */
 		/* already aligned so no need to do it below */
 	} else {
-		pSMB->PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
+		pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 		/* BB FIXME add code to fail this if NTLMv2 or Kerberos
 		   specified as required (when that support is added to
 		   the vfs in the future) as only NTLM or the much
@@ -3017,7 +3017,7 @@ CIFSTCon(unsigned int xid, struct cifsSe
 #endif /* CIFS_WEAK_PW_HASH */
 		SMBNTencrypt(tcon->password, ses->server->cryptkey, bcc_ptr);
 
-		bcc_ptr += CIFS_SESS_KEY_SIZE;
+		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
 			/* must align unicode strings */
 			*bcc_ptr = 0; /* null byte password */


