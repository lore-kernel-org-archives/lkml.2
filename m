Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2ADQdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:33:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab2ADQdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:33:19 -0500
Date: Wed, 4 Jan 2012 11:33:12 -0500
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Add Dell Studio 1557 to pci=nocrs blacklist
Message-ID: <20120104163311.GB31667@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20111230193704.GA2874@redhat.com>
 <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop>
 <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dell Studio 1557 also doesn't suspend correctly when CRS is enabled.
Details at https://bugzilla.redhat.com/show_bug.cgi?id=769657

Reported-by: Gregory S. Hoerner <ghoerner@transcendingthought.com>
Signed-off-by: Dave Jones <davej@redhat.com>
 
--- linux-3.1.noarch/arch/x86/pci/acpi.c~	2012-01-04 11:19:36.783664477 -0500
+++ linux-3.1.noarch/arch/x86/pci/acpi.c	2012-01-04 11:23:42.403666272 -0500
@@ -75,6 +75,16 @@ static const struct dmi_system_id pci_us
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
 	{
 		.callback = set_nouse_crs,
+		.ident = "Dell Studio 1557",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557");
+			DMI_MATCH(DMI_BIOS_VERSION, "A09"),
+		},
+	},
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
+	{
+		.callback = set_nouse_crs,
 		.ident = "Thinkpad SL510",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
