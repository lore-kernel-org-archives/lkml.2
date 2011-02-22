Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1BVWWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:31 -0500
Received: from kroah.org ([198.145.64.141]:32980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1BVWW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.813633543@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [58/70] cifs: Fix regression in LANMAN (LM) auth code
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 5e640927a597a7c3e72b61e8bce74c22e906de65 upstream.

LANMAN response length was changed to 16 bytes instead of 24 bytes.
Revert it back to 24 bytes.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/sess.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -667,13 +667,13 @@ ssetup_ntlmssp_authenticate:
 
 	if (type == LANMAN) {
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
-		char lnm_session_key[CIFS_SESS_KEY_SIZE];
+		char lnm_session_key[CIFS_AUTH_RESP_SIZE];
 
 		pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
 
 		/* no capabilities flags in old lanman negotiation */
 
-		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
+		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
 
 		/* Calculate hash with password and copy into bcc_ptr.
 		 * Encryption Key (stored as in cryptkey) gets used if the
@@ -686,8 +686,8 @@ ssetup_ntlmssp_authenticate:
 					true : false, lnm_session_key);
 
 		ses->flags |= CIFS_SES_LANMAN;
-		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_SESS_KEY_SIZE);
-		bcc_ptr += CIFS_SESS_KEY_SIZE;
+		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
+		bcc_ptr += CIFS_AUTH_RESP_SIZE;
 
 		/* can not sign if LANMAN negotiated so no need
 		to calculate signing key? but what if server


