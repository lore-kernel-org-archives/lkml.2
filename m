Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1I1XAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:00:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab1I1Ws0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220146.963524981@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [205/244] usb/host/pci-quirks.c: correct annotation of `ehci_dmi_nohandoff_table
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaud Lacombe <lacombar@gmail.com>

commit a7e6401e19aa54924ab11ee548afaad0a55ffdc6 upstream.

ehci_bios_handoff() is marked __devinit, `ehci_dmi_nohandoff_table' should be
marked __devinitconst, not __initconst. This fixes the following section
mismatch:

WARNING: vmlinux.o(.devinit.text+0x4f08): Section mismatch in reference from the function ehci_bios_handoff() to the variable .init.rodata:ehci_dmi_nohandoff_table
The function __devinit ehci_bios_handoff() references a variable __initconst ehci_dmi_nohandoff_table.
If ehci_dmi_nohandoff_table is only used by ehci_bios_handoff then annotate ehci_dmi_nohandoff_table with a matching annotation.

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -535,7 +535,7 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
-static const struct dmi_system_id __initconst ehci_dmi_nohandoff_table[] = {
+static const struct dmi_system_id __devinitconst ehci_dmi_nohandoff_table[] = {
 	{
 		/*  Pegatron Lucid (ExoPC) */
 		.matches = {


