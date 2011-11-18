Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab1KSAIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1KSAIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:06 2011
Message-Id: <20111119000005.957112771@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [22/26] xen-gntalloc: signedness bug in add_grefs()
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 99cb2ddcc617f43917e94a4147aa3ccdb2bcd77e upstream.

gref->gref_id is unsigned so the error handling didn't work.
gnttab_grant_foreign_access() returns an int type, so we can add a
cast here, and it doesn't cause any problems.
gnttab_grant_foreign_access() can return a variety of errors
including -ENOSPC, -ENOSYS and -ENOMEM.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/gntalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -135,7 +135,7 @@ static int add_grefs(struct ioctl_gntall
 		/* Grant foreign access to the page. */
 		gref->gref_id = gnttab_grant_foreign_access(op->domid,
 			pfn_to_mfn(page_to_pfn(gref->page)), readonly);
-		if (gref->gref_id < 0) {
+		if ((int)gref->gref_id < 0) {
 			rc = gref->gref_id;
 			goto undo;
 		}


