Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab3AIUjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:42533 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473Ab3AIUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 43/80] nfs: fix null checking in nfs_get_option_str()
Date: Wed,  9 Jan 2013 12:35:35 -0800
Message-Id: <20130109201505.921682379@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit e25fbe380c4e3c09afa98bcdcd9d3921443adab8 upstream.

The following null pointer check is broken.

	*option = match_strdup(args);
	return !option;

The pointer `option' must be non-null, and thus `!option' is always false.
Use `!*option' instead.

The bug was introduced in commit c5cb09b6f8 ("Cleanup: Factor out some
cut-and-paste code.").

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1138,7 +1138,7 @@ static int nfs_get_option_str(substring_
 {
 	kfree(*option);
 	*option = match_strdup(args);
-	return !option;
+	return !*option;
 }
 
 static int nfs_get_option_ul(substring_t args[], unsigned long *option)


