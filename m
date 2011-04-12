Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1DLOhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:37:50 -0400
Received: from kroah.org ([198.145.64.141]:57464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab1DLOhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:50 2011
Message-Id: <20110412143550.604431198@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [025/105] amd64_edac: Fix potential memleak
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit a9f0fbe2bbf328f869fc5ee5a12c6a4118c32689 upstream.

We check the pointers together but at least one of them could be invalid
due to failed allocation. Since we cannot continue if either of the two
allocations has failed, exit early by freeing them both.

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2765,7 +2765,7 @@ static int __init amd64_edac_init(void)
 	mcis	  = kzalloc(amd_nb_num() * sizeof(mcis[0]), GFP_KERNEL);
 	ecc_stngs = kzalloc(amd_nb_num() * sizeof(ecc_stngs[0]), GFP_KERNEL);
 	if (!(mcis && ecc_stngs))
-		goto err_ret;
+		goto err_free;
 
 	msrs = msrs_alloc();
 	if (!msrs)


