Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032444Ab2I1U0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61665 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032431Ab2I1U0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Baldvin Kovacs <baldvin.kovacs@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 089/218] cifs: fix return value in cifsConvertToUTF16
Date: Fri, 28 Sep 2012 13:15:06 -0700
Message-Id: <20120928201511.780518303@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 


