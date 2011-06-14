Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1FNSym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:54:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1FNSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:54:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=Qv2pphAdv4srYATLN30zh+wkFrQwSI3V1otZJzdluM8ZlY6syxZyCxkt7HWXUSlpX
	vyPQQ7SJ/2XrhdvCNMYFA==
Subject: [PATCH] x86: remove unnecessary century printk when reading RTC
To: "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Date: Tue, 14 Jun 2011 12:54:12 -0600
Message-ID: <20110614185412.7885.37450.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't print the current century every time we read the RTC.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/rtc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 3f2ad26..ecc1144 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -137,7 +137,6 @@ unsigned long mach_get_cmos_time(void)
 	if (century) {
 		century = bcd2bin(century);
 		year += century * 100;
-		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
 		year += CMOS_YEARS_OFFS;
 

