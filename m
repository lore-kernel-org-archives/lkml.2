Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1HEPBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:01:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47450 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab1HEPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:01:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 5 Aug 2011 17:01:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux-usb@vger.kernel.org
Cc: Anisse Astier <anisse@astier.eu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org
Subject: ehci post 3.0: new section mismatch of ehci_bios_handoff() to
 ehci_dmi_nohandoff_table
Message-ID: <20110805170120.4a3fd14c@stein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 03c75362181b0b1d6a330e7cf8def10ba988dfbe "ehci: refactor pci quirk
to use standard dmi_check_system method" added a new section mismatch.  A
web search shows that there is already a fix for this from Arnaud.
https://patchwork.kernel.org/patch/996112/mbox/

Unless I am looking at a wrong git tree, the fix is not committed yet.

The section mismatch:

WARNING: drivers/built-in.o(.devinit.text+0x2e37): Section mismatch in
reference from the function ehci_bios_handoff() to the
variable .init.rodata:ehci_dmi_nohandoff_table
The function __devinit ehci_bios_handoff() references
a variable __initconst ehci_dmi_nohandoff_table.
If ehci_dmi_nohandoff_table is only used by ehci_bios_handoff then
annotate ehci_dmi_nohandoff_table with a matching annotation.

-- 
Stefan Richter
-=====-==-== =--- --=-=
http://arcgraph.de/sr/
