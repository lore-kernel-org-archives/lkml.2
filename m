Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1GMAuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:50:35 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44815 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab1GMAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:50:33 -0400
MIME-Version: 1.0
Date: Tue, 12 Jul 2011 17:50:32 -0700
Message-ID: <CAFR8uecaG68Oifuz1ucpM49vaw5m420Cn0et-JQZjBjhsOes-Q@mail.gmail.com>
Subject: [PATCH]:drivers/md/raid10.c: r10buf_pool_alloc(): Set bi_vcnt for the
 new bio.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: neilb@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,
raid10.c: r10buf_pool_alloc() - doesn't set the bi_vcnt for the newly
allocated bio. Setting it to RESYNC_PAGES for successful case.

BTW, why are we not using bio_add_page() here to add the page to bio?

Signed-off-by: Muthukumar R <muthur@gmail.com>

------
 drivers/md/raid10.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
------
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e84668..8504c5b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -129,6 +129,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)

                        bio->bi_io_vec[i].bv_page = page;
                }
+               bio->bi_vcnt = RESYNC_PAGES;
        }

        return r10_bio;
