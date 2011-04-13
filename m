Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1DMQYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:24:45 -0400
Received: from kroah.org ([198.145.64.141]:52839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab1DMQM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:12:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:45 2011
Message-Id: <20110413161045.420421854@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:09:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [28/71] UBIFS: do not read flash unnecessarily
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 8b229c76765816796eec7ccd428f03bd8de8b525 upstream.

This fix makes the 'dbg_check_old_index()' function return
immediately if debugging is disabled, instead of executing
incorrect 'goto out' which causes UBIFS to:

1. Allocate memory
2. Read the flash

On every commit. OK, we do not commit that often, but it is
still silly to do unneeded I/O anyway.

Credits to coverity for spotting this silly issue.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/commit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -518,7 +518,7 @@ int dbg_check_old_index(struct ubifs_inf
 	size_t sz;
 
 	if (!(ubifs_chk_flags & UBIFS_CHK_OLD_IDX))
-		goto out;
+		return 0;
 
 	INIT_LIST_HEAD(&list);
 


