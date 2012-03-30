Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650Ab2C3VYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:24:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab2C3VXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:13 -0400
Message-Id: <20120330194851.612234495@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 127/175] PM / Domains: Check domain status during hibernation restore of devices
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

This is a backport of mainline commit
18dd2ece3cde14cfd42e95a89eb14016699a5f15.

Power domains that were off before hibernation shouldn't be turned on
during device restore, so prevent that from happening.

This change fixed up mainline commit
65533bbf63b4f37723fdfedc73d0653958973323

    PM / Domains: Fix hibernation restore of devices, v2

that didn't include it by mistake.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/domain.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1064,6 +1064,9 @@ static int pm_genpd_restore_noirq(struct
 		}
 	}
 
+	if (genpd->suspend_power_off)
+		return 0;
+
 	pm_genpd_poweron(genpd);
 	genpd_start_dev(genpd, dev);
 


