Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab2HGWbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:31:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab2HGWbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:31:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivek Trivedi <vtrivedi018@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 089/122] nfsd4: fix cr_principal comparison check in same_creds
Date: Tue,  7 Aug 2012 15:26:17 -0700
Message-Id: <20120807221957.278087044@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Trivedi <vtrivedi018@gmail.com>

commit 5559b50acdcdcad7e362882d3261bf934c9436f6 upstream.

This fixes a wrong check for same cr_principal in same_creds

Introduced by 8fbba96e5b327665265ad02b7f331b68536828bf "nfsd4: stricter
cred comparison for setclientid/exchange_id".

Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1215,7 +1215,7 @@ static bool groups_equal(struct group_in
 	return true;
 }
 
-static int
+static bool
 same_creds(struct svc_cred *cr1, struct svc_cred *cr2)
 {
 	if ((cr1->cr_flavor != cr2->cr_flavor)
@@ -1227,7 +1227,7 @@ same_creds(struct svc_cred *cr1, struct
 		return true;
 	if (!cr1->cr_principal || !cr2->cr_principal)
 		return false;
-	return 0 == strcmp(cr1->cr_principal, cr1->cr_principal);
+	return 0 == strcmp(cr1->cr_principal, cr2->cr_principal);
 }
 
 static void gen_clid(struct nfs4_client *clp)


