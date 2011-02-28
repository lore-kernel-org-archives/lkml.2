Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1B1Qpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:45:47 -0500
Received: from kroah.org ([198.145.64.141]:48110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab1B1Qho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:09 2011
Message-Id: <20110228162409.651750434@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <stf_xl@wp.pl>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [39/68] PM / Hibernate: Return error code when alloc_image_page() fails
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <stf_xl@pop3.wp.pl>

commit 2e725a065b0153f0c449318da1923a120477633d upstream.

Currently we return 0 in swsusp_alloc() when alloc_image_page() fails.
Fix that.  Also remove unneeded "error" variable since the only
useful value of error is -ENOMEM.

[rjw: Fixed up the changelog and changed subject.]

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/snapshot.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1466,11 +1466,8 @@ static int
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error = 0;
-
 	if (nr_highmem > 0) {
-		error = get_highmem_buffer(PG_ANY);
-		if (error)
+		if (get_highmem_buffer(PG_ANY))
 			goto err_out;
 		if (nr_highmem > alloc_highmem) {
 			nr_highmem -= alloc_highmem;
@@ -1493,7 +1490,7 @@ swsusp_alloc(struct memory_bitmap *orig_
 
  err_out:
 	swsusp_free();
-	return error;
+	return -ENOMEM;
 }
 
 asmlinkage int swsusp_save(void)


