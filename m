Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0DEQ5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:57:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:22835 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0DEQ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sqZf6j+/soOaa7UvWztUV1u61q9IlUBnImBmZj24Wz5H5oVGO6PgrNj6oyDs7d4A6P
         08fhwPdJA8ie8DS9iBLAPuACRmzCkpUDo/u5w4ZvT1arP1ml8Nu2A9oDdzmb3kzXWLxJ
         5bQUJNcp8pKkfZuxYpqvx+DyrYvyOk2q1Iz1o=
Date: Mon, 5 Apr 2010 20:56:57 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg KH <greg@kroah.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging, hv: Fix up memory leak on HvCleanup
Message-ID: <20100405165657.GE5079@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't assign NULL too early

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/staging/hv/Hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/drivers/staging/hv/Hv.c
=====================================================================
--- linux-2.6.git.orig/drivers/staging/hv/Hv.c
+++ linux-2.6.git/drivers/staging/hv/Hv.c
@@ -305,9 +305,9 @@ void HvCleanup(void)
 	DPRINT_ENTER(VMBUS);
 
 	if (gHvContext.SignalEventBuffer) {
+		kfree(gHvContext.SignalEventBuffer);
 		gHvContext.SignalEventBuffer = NULL;
 		gHvContext.SignalEventParam = NULL;
-		kfree(gHvContext.SignalEventBuffer);
 	}
 
 	if (gHvContext.HypercallPage) {
