Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2EJDJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:09:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38393 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2EJDJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:09:18 -0400
Date: Wed, 9 May 2012 23:09:13 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: tejun@google.com, agk@redhat.com
Subject: [Bcache v13 05/16] Export get_random_int()
Message-ID: <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for bcache - it needs a fast source of random numbers for
the throttling code in order to fuzz IO sizes, but the random numbers
don't need to be any good (and it immediately converts it to a
binomially distributed random number with popcount anyways).

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/char/random.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 54ca8b2..ec4dd79 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1357,6 +1357,7 @@ unsigned int get_random_int(void)
 
 	return ret;
 }
+EXPORT_SYMBOL(get_random_int);
 
 /*
  * randomize_range() returns a start address such that
-- 
1.7.9.rc2

