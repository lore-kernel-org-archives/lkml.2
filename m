Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2BJWov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab2BJWoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:46 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.108958973@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: [patch 32/55] cifs: Fix oops in session setup code for null user mounts
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit de47a4176c532ef5961b8a46a2d541a3517412d3 upstream.

For null user mounts, do not invoke string length function
during session setup.

Reported-and-Tested-by: Chris Clayton <chris2553@googlemail.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/sess.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -244,16 +244,15 @@ static void ascii_ssetup_strings(char **
 	/* copy user */
 	/* BB what about null user mounts - check that we do this BB */
 	/* copy user */
-	if (ses->user_name != NULL)
+	if (ses->user_name != NULL) {
 		strncpy(bcc_ptr, ses->user_name, MAX_USERNAME_SIZE);
+		bcc_ptr += strnlen(ses->user_name, MAX_USERNAME_SIZE);
+	}
 	/* else null user mount */
-
-	bcc_ptr += strnlen(ses->user_name, MAX_USERNAME_SIZE);
 	*bcc_ptr = 0;
 	bcc_ptr++; /* account for null termination */
 
 	/* copy domain */
-
 	if (ses->domainName != NULL) {
 		strncpy(bcc_ptr, ses->domainName, 256);
 		bcc_ptr += strnlen(ses->domainName, 256);


