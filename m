Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2JGXXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38667 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588Ab2JGXXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:25 -0400
Message-Id: <20121007225838.858497173@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>,
        Baldvin Kovacs <baldvin.kovacs@gmail.com>,
        Steve French <smfrench@gmail.com>
Subject: [ 030/108] cifs: fix return value in cifsConvertToUTF16
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit c73f693989d7a7d99ec66a7065295a0c93d0b127 upstream.

This function returns the wrong value, which causes the callers to get
the length of the resulting pathname wrong when it contains non-ASCII
characters.

This seems to fix https://bugzilla.samba.org/show_bug.cgi?id=6767

Reported-by: Baldvin Kovacs <baldvin.kovacs@gmail.com>
Reported-and-Tested-by: Nicolas Lefebvre <nico.lefebvre@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifs_unicode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -327,6 +327,6 @@ cifsConvertToUCS(__le16 *target, const c
 	}
 
 ctoUCS_out:
-	return i;
+	return j;
 }
 


