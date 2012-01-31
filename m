Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2AaCwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 21:52:02 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42847 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752385Ab2AaCv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 21:51:59 -0500
Message-ID: <4F2764E9.4010506@xenotime.net>
Date: Mon, 30 Jan 2012 19:50:01 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: [PATCH -next] cifs: fix printk format warnings
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
In-Reply-To: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings for ssize_t variables:

fs/cifs/connect.c:2145:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
fs/cifs/connect.c:2152:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
fs/cifs/connect.c:2160:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'
fs/cifs/connect.c:2170:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Steve French <sfrench@samba.org>
Cc:	linux-cifs@vger.kernel.org
---
 fs/cifs/connect.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20120130.orig/fs/cifs/connect.c
+++ linux-next-20120130/fs/cifs/connect.c
@@ -2142,14 +2142,14 @@ cifs_set_cifscreds(struct smb_vol *vol,
 
 	len = delim - payload;
 	if (len > MAX_USERNAME_SIZE || len <= 0) {
-		cFYI(1, "Bad value from username search (len=%ld)", len);
+		cFYI(1, "Bad value from username search (len=%zd)", len);
 		rc = -EINVAL;
 		goto out_key_put;
 	}
 
 	vol->username = kstrndup(payload, len, GFP_KERNEL);
 	if (!vol->username) {
-		cFYI(1, "Unable to allocate %ld bytes for username", len);
+		cFYI(1, "Unable to allocate %zd bytes for username", len);
 		rc = -ENOMEM;
 		goto out_key_put;
 	}
@@ -2157,7 +2157,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
 
 	len = key->datalen - (len + 1);
 	if (len > MAX_PASSWORD_SIZE || len <= 0) {
-		cFYI(1, "Bad len for password search (len=%ld)", len);
+		cFYI(1, "Bad len for password search (len=%zd)", len);
 		rc = -EINVAL;
 		kfree(vol->username);
 		vol->username = NULL;
@@ -2167,7 +2167,7 @@ cifs_set_cifscreds(struct smb_vol *vol,
 	++delim;
 	vol->password = kstrndup(delim, len, GFP_KERNEL);
 	if (!vol->password) {
-		cFYI(1, "Unable to allocate %ld bytes for password", len);
+		cFYI(1, "Unable to allocate %zd bytes for password", len);
 		rc = -ENOMEM;
 		kfree(vol->username);
 		vol->username = NULL;
