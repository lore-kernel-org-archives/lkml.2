Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1I1Wos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab1I1Wop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.077109100@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Subject: [140/244] Fix the conflict between rwpidforward and rw mount options
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve French <sfrench@us.ibm.com>

commit c9c7fa0064f4afe1d040e72f24c2256dd8ac402d upstream.

Both these options are started with "rw" - that's why the first one
isn't switched on even if it is specified. Fix this by adding a length
check for "rw" option check.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1258,7 +1258,7 @@ cifs_parse_mount_options(const char *mou
 			/* ignore */
 		} else if (strnicmp(data, "guest", 5) == 0) {
 			/* ignore */
-		} else if (strnicmp(data, "rw", 2) == 0) {
+		} else if (strnicmp(data, "rw", 2) == 0 && strlen(data) == 2) {
 			/* ignore */
 		} else if (strnicmp(data, "ro", 2) == 0) {
 			/* ignore */
@@ -1361,7 +1361,7 @@ cifs_parse_mount_options(const char *mou
 			vol->server_ino = 1;
 		} else if (strnicmp(data, "noserverino", 9) == 0) {
 			vol->server_ino = 0;
-		} else if (strnicmp(data, "rwpidforward", 4) == 0) {
+		} else if (strnicmp(data, "rwpidforward", 12) == 0) {
 			vol->rwpidforward = 1;
 		} else if (strnicmp(data, "cifsacl", 7) == 0) {
 			vol->cifs_acl = 1;


