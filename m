Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1HFAJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:09:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224Ab1HFAJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:53 2011
Message-Id: <20110806000253.380101699@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [45/55] cifs: check for NULL session password
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 24e6cf92fde1f140d8eb0bf7cd24c2c78149b6b2 upstream.

It's possible for a cifsSesInfo struct to have a NULL password, so we
need to check for that prior to running strncmp on it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1605,6 +1605,7 @@ cifs_find_smb_ses(struct TCP_Server_Info
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
+			    ses->password != NULL &&
 			    strncmp(ses->password,
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))


