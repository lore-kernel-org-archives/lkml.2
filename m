Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0LASXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:23:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:25448 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0LASXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:23:54 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288584000"; 
   d="scan'208";a="124875291"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3/5] xen: resume the pv console for hvm guests too
Date: Wed,  1 Dec 2010 18:23:28 +0000
Message-Id: <1291227810-15094-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011442280.14723@kaball-desktop>
X-OriginalArrivalTime: 01 Dec 2010 18:23:53.0110 (UTC) FILETIME=[E8690B60:01CB9184]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index ef9c7db..db8c4c4 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -49,6 +49,7 @@ static int xen_hvm_suspend(void *data)
 
 	if (!*cancelled) {
 		xen_irq_resume();
+		xen_console_resume();
 		xen_timer_resume();
 	}
 
-- 
1.5.6.5

