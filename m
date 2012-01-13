Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2AMQ3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:29:36 -0500
Received: from mx2.gd-ms.com ([153.11.250.41]:33665 "EHLO mx2.gd-ms.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab2AMQ3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:29:35 -0500
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jan 2012 11:29:35 EST
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Kushal Koolwal <kushalkoolwal@gmail.com>,
        support@versalogic.com
Cc: michael.d.labriola@gmail.com
MIME-Version: 1.0
Subject: Reboot hangs on VersaLogic Ocelot
X-KeepSent: E7865F25:43E4BFD2-85257984:0057CD12;
 type=4; name=$KeepSent
Message-ID: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
From: Michael D Labriola <mlabriol@gdeb.com>
Date: Fri, 13 Jan 2012 11:10:11 -0500
X-GDMEncrypt: FALSE
X-GDMMarking: NOT_SENSITIVE
Content-Type: text/plain; charset="US-ASCII"
X-GDM-MESSAGE-ID: X-GDM-MESSAGE-ID mx2.gd-ms.com 1Rljho-0001AH-Gm
X-GDM-EVAL: score: /30; hits: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been troubleshooting a VersaLogic Ocelot SBC that's been hanging
on reboot ever since I upgraded its BIOS.  The conclusion I've come to
is that commit e19e074 (x86: Fix reboot problem on VersaLogic Menlow
boards) needs to be reverted.

My system was rebooting fine (kernel v3.2) prior to upgrading the
BIOS, but it turns out that the DMI string being looked for in the
VersaLogic reboot quirk wasn't added until I upgraded the BIOS.

Here's a summary of the behavior I encountered on my system
(VL-EPMs-21a rev 1.00 w/ BIOS 6.5.102)

- v2.6.37 reboot=bios is needed

- v2.6.38-rc1: behavior changed, reboot=acpi is needed, reboot=kbd and
  reboot=bios result in system hang.

- v2.6.38: VersaLogic patch (e19e074 x86: Fix reboot problem on
  VersaLogic Menlow boards) was applied prior to v2.6.38-rc7.  This
  patch sets a quirk for VersaLogic Menlow boards that forces the use
  of reboot=bios, which doesn't work anymore.  As far as I can tell,
  there's no way to override this faulty quirk, as it seems to take
  precedence over the reboot= argument.

- v3.2: It seems that commit 660e34c (x86: Reorder reboot method
  preferences) changed the default reboot method to acpi prior to
  v3.0-rc1, which means the default behavior is appropriate for the
  Ocelot.  After reverting commit e19e074, my system reboots perfectly
  w/out passing any reboot= arguments.  I confirmed that this is a
  true statement for all 3 versions of the Ocelot's BIOS.

---
Michael D Labriola
Electric Boat
mlabriol@gdeb.com
401-848-8871 (desk)
401-848-8513 (lab)
401-316-9844 (cell)


 
