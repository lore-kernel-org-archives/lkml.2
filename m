Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab1HFA0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:26:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab1HFAJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:53 2011
Message-Id: <20110806000253.290593535@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [44/55] cifs: fix NULL pointer dereference in cifs_find_smb_ses
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit fc87a40677bbe0937e2ff0642c7e83c9a4813f3d upstream.

cifs_find_smb_ses assumes that the vol->password field is a valid
pointer, but that's only the case if a password was passed in via
the options string. It's possible that one won't be if there is
no mount helper on the box.

Reported-by: diabel <gacek-2004@wp.pl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1605,7 +1605,8 @@ cifs_find_smb_ses(struct TCP_Server_Info
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
-			    strncmp(ses->password, vol->password,
+			    strncmp(ses->password,
+				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))
 				continue;
 		}


