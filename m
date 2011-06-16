Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1FPHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60288 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab1FPHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:49 -0400
X-Sasl-enc: X1oUonGX8ltaRHUxG4mybehsTFHtIHD6qX6RA8X5SYzB 1308207708
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:37 2011
Message-Id: <20110616000237.113017616@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>
Subject: [83/89] TOMOYO: Fix oops in tomoyo_mount_acl().
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 4e78c724d47e2342aa8fde61f6b8536f662f795f upstream.

In tomoyo_mount_acl() since 2.6.36, kern_path() was called without checking
dev_name != NULL. As a result, an unprivileged user can trigger oops by issuing
mount(NULL, "/", "ext3", 0, NULL) request.
Fix this by checking dev_name != NULL before calling kern_path(dev_name).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/tomoyo/mount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/tomoyo/mount.c
+++ b/security/tomoyo/mount.c
@@ -138,7 +138,7 @@ static int tomoyo_mount_acl(struct tomoy
 	}
 	if (need_dev) {
 		/* Get mount point or device file. */
-		if (kern_path(dev_name, LOOKUP_FOLLOW, &path)) {
+		if (!dev_name || kern_path(dev_name, LOOKUP_FOLLOW, &path)) {
 			error = -ENOENT;
 			goto out;
 		}


