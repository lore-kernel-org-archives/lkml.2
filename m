Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab0J2AaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:30:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49774 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab0J2AaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=NbCE9UV8RSACS1T7h/5MIxLbZTTdaNZE0YlUiN0rJQr6MhRI5sS5SiQXQ7w1K8x66w
         X/dzDNWf13PQfMTX5BbS5hpV5jYcEcsSbP0klHkWufnmHYVqGfZP/8LK8XWTIQ1X77fl
         QUilcJAFCcOdON8wZ+q4P70zJ1iQ355EWJiAU=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] power: Fix typo in status comparison causing warning
Date: Thu, 28 Oct 2010 21:29:52 -0300
Message-Id: <1288312192-28909-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC version 4.5.1 gives the following warning:

	drivers/base/power/runtime.c: In function ‘rpm_check_suspend_allowed’:
	drivers/base/power/runtime.c:146:25: warning: comparison between ‘enum dpm_state’ and ‘enum rpm_status’

which seems to be a typo in that dev->power.runtime_status
should be compared instead of dev->power.status.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 drivers/base/power/runtime.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 126ca49..02c652b 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -143,7 +143,7 @@ static int rpm_check_suspend_allowed(struct device *dev)
 
 	/* Pending resume requests take precedence over suspends. */
 	else if ((dev->power.deferred_resume
-			&& dev->power.status == RPM_SUSPENDING)
+			&& dev->power.runtime_status == RPM_SUSPENDING)
 	    || (dev->power.request_pending
 			&& dev->power.request == RPM_REQ_RESUME))
 		retval = -EAGAIN;
-- 
1.7.3.2

