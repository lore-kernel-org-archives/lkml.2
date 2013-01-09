Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3AIUu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:50:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:43891 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933999Ab3AIUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fadeeva Marina <astarta@rat.ru>, Myron Stowe <myron.stowe@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 107/123] PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)
Date: Wed,  9 Jan 2013 12:35:46 -0800
Message-Id: <20130109201512.206422838@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myron Stowe <myron.stowe@redhat.com>

commit 1278998f8ff6d66044ed00b581bbf14aacaba215 upstream.

Commit 284f5f9 was intended to disable the "only_one_child()" optimization
on Stratus ftServer systems, but its DMI check is wrong.  It looks for
DMI_SYS_VENDOR that contains "ftServer", when it should look for
DMI_SYS_VENDOR containing "Stratus" and DMI_PRODUCT_NAME containing
"ftServer".

Tested on Stratus ftServer 6400.

Reported-by: Fadeeva Marina <astarta@rat.ru>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=51331
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -433,7 +433,8 @@ static const struct dmi_system_id __devi
 		.callback = set_scan_all,
 		.ident = "Stratus/NEC ftServer",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ftServer"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Stratus"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ftServer"),
 		},
 	},
 	{}


