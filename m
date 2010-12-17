Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0LQRNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 12:13:50 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0LQRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gukbODJc3tWdnm26HldPb0TFp50v/qKzIa67qF9MO5aUKpqPL6KLSJsr+C+JU5mpej
         u8n+yLgcENaU1CuhHZWyTRX+3Nkfb06C6BWOgPl8t1WvKYWCfCC9mwSzhAxutYylePv4
         quTlZaD6IA+J7fD4s6KnLTonR7kXMuCMGksPo=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [RFC 0/5] Change page reference hanlding semantic of page cache
Date: Sat, 18 Dec 2010 02:13:35 +0900
Message-Id: <cover.1292604745.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I copy description of 1/5.

Now we add page reference on add_to_page_cache but doesn't drop it
in remove_from_page_cache. Such asymmetric makes confusing about
page reference so that caller should notice it and comment why they
release page reference. It's not good API.

Long time ago, Hugh tried it[1] but gave up of reason which
reiser4's drop_page had to unlock the page between removing it from
page cache and doing the page_cache_release. But now the situation is
changed. I think at least things in current mainline doesn't have any
obstacles. The problem is fs or somethings out of mainline.
If it has done such thing like reiser4, this patch could be a problem.

Do anyone know the such things? Do we care about things out of mainline?

[1] http://lkml.org/lkml/2004/10/24/140

Minchan Kim (5):
  drop page reference on remove_from_page_cache
  fuse: Remove unnecessary page release
  tlbfs: Remove unnecessary page release
  swap: Remove unnecessary page release
  truncate: Remove unnecessary page release

 fs/fuse/dev.c        |    1 -
 fs/hugetlbfs/inode.c |    1 -
 mm/filemap.c         |   12 ++++++++++++
 mm/shmem.c           |    1 -
 mm/truncate.c        |    1 -
 5 files changed, 12 insertions(+), 4 deletions(-)

