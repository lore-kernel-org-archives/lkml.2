Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031584Ab2I1Tn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:43:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235Ab2I1S73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Baldvin Kovacs <baldvin.kovacs@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 114/262] cifs: fix return value in cifsConvertToUTF16
Date: Fri, 28 Sep 2012 11:50:43 -0700
Message-Id: <20120928183011.592684909@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifs_unicode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -328,6 +328,6 @@ cifsConvertToUTF16(__le16 *target, const
 	}
 
 ctoUTF16_out:
-	return i;
+	return j;
 }
 


