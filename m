Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab1LGQRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:17:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab1LGQRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:25 2011
Message-Id: <20111207160825.626823550@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:56 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        stable@kernel.org
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg KH <greg@kroah.com>, Jean Delvare <khali@linux-fr.org>,
        Durgadoss R <durgadoss.r@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [36/80] hwmon: (coretemp) Fix oops on driver load
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

This is for stable kernel branch 3.0 only. Previous and later versions
have different code paths and are not affected by this bug.

If the CPU microcode is too old, the coretemp driver won't work. But
instead of failing gracefully, it currently oops. Check for NULL
platform device data to avoid this.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -539,6 +539,8 @@ static void coretemp_add_core(unsigned i
 		return;
 
 	pdata = platform_get_drvdata(pdev);
+	if (!pdata)
+		return;
 
 	err = create_core_data(pdata, pdev, cpu, pkg_flag);
 	if (err)


