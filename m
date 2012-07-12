Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161837Ab2GLXdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:33:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161812Ab2GLWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 079/187] ACPI: Remove one board specific WARN when ignoring timer overriding
Date: Thu, 12 Jul 2012 15:33:55 -0700
Message-Id: <20120712191529.739576639@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 7f68b4c2e158019c2ec494b5cfbd9c83b4e5b253 upstream.

Current WARN msg is only for the ati_ixp4x0 board, while this function
is used by mulitple platforms. So this one board specific warning
is not appropriate any more.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/acpi/boot.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1340,12 +1340,7 @@ static int __init dmi_disable_acpi(const
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
-	/*
-	 * The ati_ixp4x0_rev() early PCI quirk should have set
-	 * the acpi_skip_timer_override flag already:
-	 */
 	if (!acpi_skip_timer_override) {
-		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
 		pr_notice("%s detected: Ignoring BIOS IRQ0 override\n",
 			d->ident);
 		acpi_skip_timer_override = 1;


