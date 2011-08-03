Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1HCX01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:26:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab1HCX0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:45 2011
Message-Id: <20110803221245.095742883@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [010/102] Staging: hv: vmbus: Increase the timeout value in the vmbus driver
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 2dfde9644fe8c4a77f9c73f95b25d6300ca23b5d upstream.

On some loaded windows hosts, we have discovered that the host may not
respond to guest requests within the specified time (one second)
as evidenced by the guest timing out. Fix this problem by increasing
the timeout to 5 seconds.

It may be useful to apply this patch to the 3.0 kernel as well.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/channel.c      |    2 +-
 drivers/staging/hv/channel_mgmt.c |    2 +-
 drivers/staging/hv/connection.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -212,7 +212,7 @@ int vmbus_open(struct vmbus_channel *new
 	if (ret != 0)
 		goto Cleanup;
 
-	t = wait_for_completion_timeout(&openInfo->waitevent, HZ);
+	t = wait_for_completion_timeout(&openInfo->waitevent, 5*HZ);
 	if (t == 0) {
 		err = -ETIMEDOUT;
 		goto errorout;
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -773,7 +773,7 @@ int vmbus_request_offers(void)
 		goto cleanup;
 	}
 
-	t = wait_for_completion_timeout(&msginfo->waitevent, HZ);
+	t = wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
 	if (t == 0) {
 		ret = -ETIMEDOUT;
 		goto cleanup;
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -135,7 +135,7 @@ int vmbus_connect(void)
 	}
 
 	/* Wait for the connection response */
-	t =  wait_for_completion_timeout(&msginfo->waitevent, HZ);
+	t =  wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
 	if (t == 0) {
 		spin_lock_irqsave(&vmbus_connection.channelmsg_lock,
 				flags);


