Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1GLVRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 17:17:32 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6848 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1GLVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 17:17:31 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, mingo@elte.hu,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Message-Id: <20110712211653.2939.11833.sendpatchset@nchumbalkar.americas.cpqcorp.net>
Subject: [PATCH v2 0/2] x86, ioapic: Consider IR when printing out IOAPIC related output
Date: Tue, 12 Jul 2011 21:17:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is v2 of the patchset. This should apply cleanly to your latest
"linux-2.6-x86" tree.

v2 --> v1:
Made changes to the first patch so the output changes from:

 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 00 0000 0   1    0    0   0   0    0     0    00
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 01 000F 1   0    0    0   0   0    0     0    01
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 02 0001 1   0    0    0   0   0    0     0    02
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 03 0002 1   1    0    0   0   0    0     0    03
 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 04 0011 1   1    0    0   0   0    0     0    04
...

to:

 NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:
 00 0000 0   1    0    0   0   0    0     0    00
 01 000F 1   0    0    0   0   0    0     0    01
 02 0001 1   0    0    0   0   0    0     0    02
 03 0002 1   1    0    0   0   0    0     0    03
 04 0011 1   1    0    0   0   0    0     0    04
...

No changes made to the second patch.

v1 is here:
http://comments.gmane.org/gmane.linux.kernel/1166485

This patchset is not 3.0 material, and can wait.

Naga Chumbalkar (2):
  Print IR_IO_APIC_route_entry when IR is enabled
  Print IRTE when IR is enabled

 arch/x86/kernel/apic/io_apic.c |   81 +++++++++++++++++++++++++++++----------
 1 files changed, 60 insertions(+), 21 deletions(-)

