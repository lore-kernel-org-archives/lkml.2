Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1AONCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:02:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1AONCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:02:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] ACPI: don't attempt to use hest_tab unless !acpi_pci_disabled
Date: Sat, 15 Jan 2011 14:01:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20110114181620.188e7a62@queued.net> <alpine.LFD.2.02.1101142310240.2551@x980> <20110114235437.669f820d@queued.net>
In-Reply-To: <20110114235437.669f820d@queued.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101151401.18846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 15, 2011, Andres Salomon wrote:
> On Fri, 14 Jan 2011 23:24:27 -0500 (EST)
> Len Brown <lenb@kernel.org> wrote:
> 
> [...]
> > > This patch causes apei_hest_parse to check both hest_disabled and
> > > acpi_pci_disabled before continuing.  With it, the XO-1 boots
> > > properly.
> > 
> > The X0-1 has no ACPI support, and thus you are running
> > with acpi_disabled=1, yes?
> 
> The XO-1 has no ACPI support, but ACPI support is enabled in the kernel
> (as the XO-1.5 does have ACPI support, and the same kernel is used
> between both) and I'm not passing any arguments to the kernel regarding
> it. The kernel's ACPI code detects that it's not there and disables it
> (the kernel message that's seen is "ACPI: Interpreter disabled.")
> 
> This is what sets apci_pci_disabled to 1; I'm not doing it manually.

Hmm.  Does the appended patch help instead?

Rafael

---
 drivers/acpi/pci_root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -631,11 +631,11 @@ static int acpi_pci_root_remove(struct a
 
 static int __init acpi_pci_root_init(void)
 {
+	acpi_hest_init();
+
 	if (acpi_pci_disabled)
 		return 0;
 
-	acpi_hest_init();
-
 	pci_acpi_crs_quirks();
 	if (acpi_bus_register_driver(&acpi_pci_root_driver) < 0)
 		return -ENODEV;
