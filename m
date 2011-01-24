Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AXLHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:07:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54642 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1AXLG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BWIusyXUyjSvS2kQgq8L8FjqXMcC40/uc3+has0xqeI3AY+Ud/8uHy5NRrlHTVT6KY
         E2b5mfF+1+86GcTqJNEpG+SiSQdgDWwlm1Jjwk1JBEGXHZRSJ6jZeAE2hQwgnDNHX1rJ
         D2pBob3oSuX9/mUHSr7cqdLApSCPTGT/CALoI=
Date: Mon, 24 Jan 2011 12:06:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH] RDMA: update missed converion of flush_scheduled_work()
Message-ID: <20110124110654.GA11404@htj.dyndns.org>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-2-git-send-email-tj@kernel.org>
 <adamxn0yujn.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamxn0yujn.fsf@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f0626710 (d9112f11586830d22501d0e26245ea) introduced ib_wq and
removed the use of flush_scheduled_work(); however, during merge
process one chunk was lost in ib_sa_remove_one().  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/core/sa_query.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/drivers/infiniband/core/sa_query.c
===================================================================
--- work.orig/drivers/infiniband/core/sa_query.c
+++ work/drivers/infiniband/core/sa_query.c
@@ -1079,7 +1079,7 @@ static void ib_sa_remove_one(struct ib_d
 
 	ib_unregister_event_handler(&sa_dev->event_handler);
 
-	flush_scheduled_work();
+	flush_workqueue(ib_wq);
 
 	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
 		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND) {
