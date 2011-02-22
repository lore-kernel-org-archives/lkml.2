Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1BVWaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:30:03 -0500
Received: from kroah.org ([198.145.64.141]:46754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1BVWVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.615446929@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <stf_xl@wp.pl>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [36/70] PM / Hibernate: Return error code when alloc_image_page() fails
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1519,11 +1519,8 @@ static int
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
@@ -1546,7 +1543,7 @@ swsusp_alloc(struct memory_bitmap *orig_
 
  err_out:
 	swsusp_free();
-	return error;
+	return -ENOMEM;
 }
 
 asmlinkage int swsusp_save(void)


