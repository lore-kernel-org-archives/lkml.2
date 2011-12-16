Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab1LPTyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:54:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964848Ab1LPTwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:11 2011
Message-Id: <20111216194211.684013527@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, stable@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg KH <greg@kroah.com>, Jean Delvare <khali@linux-fr.org>,
        Durgadoss R <durgadoss.r@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [30/45] hwmon: (coretemp) Fix oops on CPU offlining
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

This is for stable kernel branch 3.0 only. Previous and later versions
have different code paths and are not affected by this bug.

This is the same fix as "hwmon: (coretemp) Fix oops on driver load"
but for the CPU offlining case. Sorry for missing it at first.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Durgadoss R <durgadoss.r@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -747,6 +747,8 @@ static void __cpuinit put_core_offline(u
 		return;
 
 	pdata = platform_get_drvdata(pdev);
+	if (!pdata)
+		return;
 
 	indx = TO_ATTR_NO(cpu);
 


