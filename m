Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1KYM0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:26:55 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52232 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1KYM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:26:54 -0500
MIME-Version: 1.0
Date: Fri, 25 Nov 2011 20:20:31 +0800
Message-ID: <CAJd=RBChfVC4hUKvO5ks0+NxahTgibdivLotw3VpAa7_-r8_+g@mail.gmail.com>
Subject: [PATCH] mm: migration: pair unlock_page and lock_page when migrating
 huge pages
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip unlocking page if fail to lock, then lock and unlock are paired.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/migrate.c	Fri Nov 25 20:11:14 2011
+++ b/mm/migrate.c	Fri Nov 25 20:21:26 2011
@@ -869,9 +869,9 @@ static int unmap_and_move_huge_page(new_

 	if (anon_vma)
 		put_anon_vma(anon_vma);
-out:
 	unlock_page(hpage);

+out:
 	if (rc != -EAGAIN) {
 		list_del(&hpage->lru);
 		put_page(hpage);
