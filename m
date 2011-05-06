Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1EFQDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:03:40 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:41357 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1EFQDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=TY95IwcyP6j6J9AccRHOAylg59WT6aqoMS35828+Yn8Vzz5dKyVUmU/5u1nBn3tUF5
         wxQgeeAfxeq8f0tCJfWLwqxExlmHURDxbjuPLyVLs44V0BGitVwqIBH4MLlgWQng+pVL
         8p/N4rZYo6Hw+Ic0fI7pl6Oo8l95NaeH2LWeU=
Subject: [PATCH]mm/migrate.c: clean up comment
From: "Figo.zhang" <figo1802@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@osdl.org>
Date: Sat, 07 May 2011 00:03:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 7bit
Message-ID: <1304697799.2450.9.camel@figo-desktop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up comment. prepare cgroup return 0 or -ENOMEN, others return -EAGAIN.
avoid conflict meanings.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---
mm/migrate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 34132f8..d65b351 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -647,7 +647,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		if (unlikely(split_huge_page(page)))
 			goto move_newpage;
 
-	/* prepare cgroup just returns 0 or -ENOMEM */
 	rc = -EAGAIN;
 
 	if (!trylock_page(page)) {
@@ -687,7 +686,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		goto unlock;
 	}
 
-	/* charge against new page */
+	/* charge against new page, return 0 or -ENOMEM */
 	charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
 	if (charge == -ENOMEM) {
 		rc = -ENOMEM;


