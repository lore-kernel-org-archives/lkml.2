Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2BGKb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:31:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59110 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2BGKb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:31:26 -0500
Subject: [PATCH BUGFIX] mm: fix find_get_page() for shmem exceptional entries
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 07 Feb 2012 14:31:21 +0400
Message-ID: <20120207103121.28345.28611.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should return NULL, otherwise the caller will be very surprised.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/filemap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 518223b..ca98cb5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -693,6 +693,7 @@ repeat:
 			 * here as an exceptional entry: so return it without
 			 * attempting to raise page count.
 			 */
+			page = NULL;
 			goto out;
 		}
 		if (!page_cache_get_speculative(page))

