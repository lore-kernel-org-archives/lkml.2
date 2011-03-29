Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1C2XOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:14:55 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40585 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1C2XOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:14:54 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com
Subject: [PATCH] blk-throttle: don't call xchg on bool
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
	<1292447255-10698-3-git-send-email-vgoyal@redhat.com>
X-Yow: Feel th' WHIRLING BUFFERS buffing away all that stress...
 Years of ROAD TAR gently washing away...
Date: Wed, 30 Mar 2011 01:14:50 +0200
In-Reply-To: <1292447255-10698-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Wed, 15 Dec 2010 16:07:35 -0500")
Message-ID: <m21v1ph639.fsf_-_@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xchg does not work portably with smaller than 32bit types.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 block/blk-throttle.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5352bda..6c98cfe 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -77,7 +77,7 @@ struct throtl_grp {
 	unsigned long slice_end[2];
 
 	/* Some throttle limits got updated for the group */
-	bool limits_changed;
+	int limits_changed;
 };
 
 struct throtl_data
@@ -102,7 +102,7 @@ struct throtl_data
 	/* Work for dispatching throttled bios */
 	struct delayed_work throtl_work;
 
-	bool limits_changed;
+	int limits_changed;
 };
 
 enum tg_state_flags {
-- 
1.7.4.2


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
