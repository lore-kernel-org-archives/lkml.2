Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2L1TbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:31:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55543 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363Ab2L1TTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:22 -0500
Message-Id: <20121228190342.938733849@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 061/173] ext4: init pagevec in ext4_da_block_invalidatepages
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 66bea92c69477a75a5d37b9bfed5773c92a3c4b4 upstream.

ext4_da_block_invalidatepages is missing a pagevec_init(),
which means that pvec->cold contains random garbage.

This affects whether the page goes to the front or
back of the LRU when ->cold makes it to
free_hot_cold_page()

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1422,6 +1422,7 @@ static void ext4_da_block_invalidatepage
 
 	index = mpd->first_page;
 	end   = mpd->next_page - 1;
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)


