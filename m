Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1I1Wli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1I1Wlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220134.474231537@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Venkateswararao=20Jujjuri=20@suse.de,
        "?= <jvrao@linux.vnet.ibm.com>, "@suse.de, Aneesh@suse.de,
        Kumar@suse.de, K.V@suse.de,
        " <aneesh.kumar@linux.vnet.ibm.com>, Eric Van Hensbergen <ericvh@gmail.com>"@suse.de
Subject: [087/244] net/9p: Fix the msize calculation.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>

commit c9ffb05ca5b5098d6ea468c909dd384d90da7d54 upstream.

msize represents the maximum PDU size that includes P9_IOHDRSZ.

Signed-off-by: Venkateswararao Jujjuri "<jvrao@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -822,8 +822,8 @@ struct p9_client *p9_client_create(const
 	if (err)
 		goto destroy_fidpool;
 
-	if ((clnt->msize+P9_IOHDRSZ) > clnt->trans_mod->maxsize)
-		clnt->msize = clnt->trans_mod->maxsize-P9_IOHDRSZ;
+	if (clnt->msize > clnt->trans_mod->maxsize)
+		clnt->msize = clnt->trans_mod->maxsize;
 
 	err = p9_client_version(clnt);
 	if (err)


