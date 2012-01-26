Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2AZVnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:43:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2AZVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:43:05 -0500
Date: Thu, 26 Jan 2012 13:42:41 -0800
From: tip-bot for Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <tip-rh1jaft9tjpzfql76gd56h1q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, kirill.shutemov@linux.intel.com,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com,
        mika.westerberg@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/mrst: Add msic_thermal platform support
Git-Commit-ID: ecfdb0ac15ba983ba4ff11709fdf8f178c0b8b87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:42:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ecfdb0ac15ba983ba4ff11709fdf8f178c0b8b87
Gitweb:     http://git.kernel.org/tip/ecfdb0ac15ba983ba4ff11709fdf8f178c0b8b87
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Thu, 26 Jan 2012 17:36:08 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:23:56 +0100

x86/mrst: Add msic_thermal platform support

This will let the MSIC driver to create platform device for the
thermal driver.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: jacob.jun.pan@linux.intel.com
Link: http://lkml.kernel.org/n/tip-rh1jaft9tjpzfql76gd56h1q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/mrst/mrst.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 6743587..721e652 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -670,6 +670,11 @@ static void *msic_ocd_platform_data(void *info)
 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
 }
 
+static void *msic_thermal_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
+}
+
 static const struct devs_id __initconst device_ids[] = {
 	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
@@ -689,6 +694,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
 	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
 	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
 
 	{},
 };
