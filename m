Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0KDGk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:40:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:30152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab0KDGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:40:56 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>, stable <stable@kernel.org>
Subject: [PATCH] pm_qos: Fix reversed min and max
Date: Wed,  3 Nov 2010 23:40:03 -0700
Message-Id: <1288852803-12356-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_qos_get_value had min and max reversed, causing all pm_qos
requests to have no effect.

Change-Id: I252c764821eac8d94de57eb482c05bf6afcea15b
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark gross <markgross@thegnar.org>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/pm_qos_params.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 645e541..0da2837 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -120,10 +120,10 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
 
 	switch (o->type) {
 	case PM_QOS_MIN:
-		return plist_last(&o->requests)->prio;
+		return plist_first(&o->requests)->prio;
 
 	case PM_QOS_MAX:
-		return plist_first(&o->requests)->prio;
+		return plist_last(&o->requests)->prio;
 
 	default:
 		/* runtime check for not using enum */
-- 
1.7.3.1

