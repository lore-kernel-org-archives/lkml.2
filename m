Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab1KJF05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:26:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933875Ab1KJDVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:00 2011
Message-Id: <20111109212700.403814699@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@samba.org>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <smfrench@gmail.com>
Subject: [001/262] CIFS: Fix incorrect max RFC1002 write size value
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 94443f43404239c2a6dc4252a7cb9e77f5b1eb6e upstream.

..the length field has only 17 bits.

Acked-by: Jeff Layton <jlayton@samba.org>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2767,10 +2767,10 @@ void cifs_setup_cifs_sb(struct smb_vol *
 
 /*
  * When the server doesn't allow large posix writes, only allow a wsize of
- * 128k minus the size of the WRITE_AND_X header. That allows for a write up
+ * 2^17-1 minus the size of the WRITE_AND_X header. That allows for a write up
  * to the maximum size described by RFC1002.
  */
-#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
+#define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
 
 /*
  * The default wsize is 1M. find_get_pages seems to return a maximum of 256


