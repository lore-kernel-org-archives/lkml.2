Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab1KSAK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:10:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab1KSAKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.688892178@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [20/26] xen-gntalloc: integer overflow in gntalloc_ioctl_alloc()
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 21643e69a4c06f7ef155fbc70e3fba13fba4a756 upstream.

On 32 bit systems a high value of op.count could lead to an integer
overflow in the kzalloc() and gref_ids would be smaller than
expected.  If the you triggered another integer overflow in
"if (gref_size + op.count > limit)" then you'd probably get memory
corruption inside add_grefs().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/gntalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -280,7 +280,7 @@ static long gntalloc_ioctl_alloc(struct
 		goto out;
 	}
 
-	gref_ids = kzalloc(sizeof(gref_ids[0]) * op.count, GFP_TEMPORARY);
+	gref_ids = kcalloc(op.count, sizeof(gref_ids[0]), GFP_TEMPORARY);
 	if (!gref_ids) {
 		rc = -ENOMEM;
 		goto out;


