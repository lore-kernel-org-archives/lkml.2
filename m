Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab0E2EuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 00:50:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37999 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0E2EuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 00:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=TGukIzDJW+YP+AqvZPfjvUUUri7UaN0qplbu0zHFAik8nxHjLcjzwqoVR/sE/AP3fG
         9+hDrQ0yNYdAVQujiLxRaT6ZWXlhr1Y3EeTaVvslwlDTKME56odnixtFeUTkjFPgjKAR
         w9rgbngeH0/tym6fhiCp29OFdBzLIYU31hGBI=
Date: Fri, 28 May 2010 21:50:27 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] complain when users abuse the pm_qos API
Message-ID: <20100529045027.GE11600@gvim.org>
Reply-To: markgross@thegnar.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is to help clean up API abusers of pm_qos where
they call update_request before registering a request.

--mgross

--Signed-off-by: markgross <markgross@thegnar.org>


>From a0813007ddc7b72cb3da7a533fefba9889aab1d8 Mon Sep 17 00:00:00 2001
From: mgross <mgross@mgross-desktop.(none)>
Date: Fri, 28 May 2010 21:36:06 -0700
Subject: [PATCH] complain when users abuse the pm_qos API by updating a request that
 isn't registered yet.

---
 kernel/pm_qos_params.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index f42d3f7..8e55bf1 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -266,6 +266,10 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
 		spin_unlock_irqrestore(&pm_qos_lock, flags);
 		if (pending_update)
 			update_target(pm_qos_req->pm_qos_class);
+	} else {
+		WARN(true, "pm_qos: updating an unregistered request "
+				"does nothing");
+		dump_stack();
 	}
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_request);
-- 
1.7.0.4

