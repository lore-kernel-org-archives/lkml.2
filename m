Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2HDECu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:02:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2HDECq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:02:46 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 09/15] firmware loader: fix comments on request_firmware_nowait
Date: Sat,  4 Aug 2012 12:01:24 +0800
Message-Id: <1344052890-31935-10-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_firmware_nowait is allowed to be called in atomic
context now if @gfp is GFP_ATOMIC, so fix the obsolete
comments and states which situations are suitable for using
it.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7d3a83b..a47266c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -846,9 +846,13 @@ static void request_firmware_work_func(struct work_struct *work)
  *
  *	Caller must hold the reference count of @device.
  *
- *	Asynchronous variant of request_firmware() for user contexts where
- *	it is not possible to sleep for long time. It can't be called
- *	in atomic contexts.
+ *	Asynchronous variant of request_firmware() for user contexts:
+ *		- sleep for as small periods as possible since it may
+ *		increase kernel boot time of built-in device drivers
+ *		requesting firmware in their ->probe() methods, if
+ *		@gfp is GFP_KERNEL.
+ *
+ *		- can't sleep at all if @gfp is GFP_ATOMIC.
  **/
 int
 request_firmware_nowait(
-- 
1.7.9.5

