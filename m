Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2JSD2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:28:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:51408 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab2JSCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>, NeilBrown <neilb@suse.de>
Subject: [ 31/62] md/raid10: use correct limit variable
Date: Thu, 18 Oct 2012 19:44:59 -0700
Message-Id: <20121019024301.003315745@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 91502f099dfc5a1e8812898e26ee280713e1d002 upstream.

Clang complains that we are assigning a variable to itself.  This should
be using bad_sectors like the similar earlier check does.

Bug has been present since 3.1-rc1.  It is minor but could
conceivably cause corruption or other bad behaviour.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3019,7 +3019,7 @@ static sector_t sync_request(struct mdde
 				else {
 					bad_sectors -= (sector - first_bad);
 					if (max_sync > bad_sectors)
-						max_sync = max_sync;
+						max_sync = bad_sectors;
 					continue;
 				}
 			}


