Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2GPRcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:32:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60179 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2GPRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:32:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207161220440.32319@router.home>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207161220440.32319@router.home>
Date: Tue, 17 Jul 2012 02:32:07 +0900
Message-ID: <CAAmzW4P0Pa5-gM7mDnqBXCC=g3zk-z_7pXbR7XPM6Tv6CcVJiw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
From: JoonSoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Christoph Lameter <cl@linux.com>:
> On Tue, 17 Jul 2012, Joonsoo Kim wrote:
>
>> migrate_pages() should return number of pages not migrated or error code.
>> When unmap_and_move return -EAGAIN, outer loop is re-execution without
>> initialising nr_failed. This makes nr_failed over-counted.
>
> The itention of the nr_failed was only to give an indication as to how
> many attempts where made. The failed pages where on a separate queue that
> seems to have vanished.
>
>> So this patch correct it by initialising nr_failed in outer loop.
>
> Well yea it makes sense since retry is initialized there as well.
>
> Acked-by: Christoph Lameter <cl@linux.com>

Thanks for comment.

Additinally, I find that migrate_huge_pages() is needed identical fix
as migrate_pages().

@@ -1029,6 +1030,7 @@ int migrate_huge_pages(struct list_head *from,

        for (pass = 0; pass < 10 && retry; pass++) {
                retry = 0;
+               nr_failed = 0;

                list_for_each_entry_safe(page, page2, from, lru) {
                        cond_resched();

When I resend with this, could I include "Acked-by: Christoph Lameter
<cl@linux.com>"?
