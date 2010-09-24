Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0IXQ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:31 -0400
Received: from kroah.org ([198.145.64.141]:38360 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab0IXQ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:28 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.360011635@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [40/80] mmap: call unlink_anon_vmas() in __split_vma() in case of error
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit 2aeadc30de45a72648f271603203ab392b80f607 upstream.

If __split_vma fails because of an out of memory condition the
anon_vma_chain isn't teardown and freed potentially leading to rmap walks
accessing freed vma information plus there's a memleak.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1997,6 +1997,7 @@ static int __split_vma(struct mm_struct
 			removed_exe_file_vma(mm);
 		fput(new->vm_file);
 	}
+	unlink_anon_vmas(new);
  out_free_mpol:
 	mpol_put(pol);
  out_free_vma:


