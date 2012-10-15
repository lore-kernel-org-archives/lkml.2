Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2JOVnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:43:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab2JOVnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:43:05 -0400
Date: Mon, 15 Oct 2012 23:42:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [RESEND] [PATCH 1/2] random: make it possible to enable debugging
 without rebuild
In-Reply-To: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1210152340390.14002@pobox.suse.cz>
References: <alpine.LNX.2.00.1210081637170.28357@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module parameter that turns debugging mode (which basically means 
printing a few extra lines during runtime) is in '#if 0' block. Forcing 
everyone who would like to see how entropy is behaving on his system to 
rebuild seems to be a little bit too harsh.

If we were concerned about speed, we could potentially turn 'debug' into a 
static key, but I don't think it's necessary.

Drop the '#if 0' block to allow using the 'debug' parameter without rebuilding.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/char/random.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..9ac4443 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -399,7 +399,6 @@ static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
-#if 0
 static bool debug;
 module_param(debug, bool, 0644);
 #define DEBUG_ENT(fmt, arg...) do { \
@@ -410,9 +409,6 @@ module_param(debug, bool, 0644);
 		blocking_pool.entropy_count,\
 		nonblocking_pool.entropy_count,\
 		## arg); } while (0)
-#else
-#define DEBUG_ENT(fmt, arg...) do {} while (0)
-#endif
 
 /**********************************************************************
  *

-- 
Jiri Kosina
SUSE Labs
