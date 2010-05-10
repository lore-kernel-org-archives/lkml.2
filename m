Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab0EJXjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:39:18 -0400
Received: from kroah.org ([198.145.64.141]:33045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab0EJWwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:20 2010
Message-Id: <20100510223320.717905348@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: [039/117] Staging: hv: Fix up memory leak on HvCleanup
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cyrill Gorcunov <gorcunov@openvz.org>

commit fa8ad0257ea256381126ecf447694622216c600f upstream.

Don't assign NULL too early

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/Hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/hv/Hv.c
+++ b/drivers/staging/hv/Hv.c
@@ -306,9 +306,9 @@ void HvCleanup(void)
 	DPRINT_ENTER(VMBUS);
 
 	if (gHvContext.SignalEventBuffer) {
+		kfree(gHvContext.SignalEventBuffer);
 		gHvContext.SignalEventBuffer = NULL;
 		gHvContext.SignalEventParam = NULL;
-		kfree(gHvContext.SignalEventBuffer);
 	}
 
 	if (gHvContext.GuestId == HV_LINUX_GUEST_ID) {


