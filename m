Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0JALJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:09:46 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:53900 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0JALJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:09:45 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2010 07:09:45 EDT
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: 2.6.36-rc5 i915 regression
Date: Fri, 1 Oct 2010 13:00:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010011300.06298.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.36-rc5 and later my netbook is unusable. After login on X (KDE) the
screen gets totally garbled, under X and console too. The log shows me this
messages:

Sep 30 21:20:01 netbook kernel: render error detected, EIR: 0x00000010
Sep 30 21:20:01 netbook kernel: page table error
Sep 30 21:20:01 netbook kernel: PGTBL_ER: 0x00100113
Sep 30 21:20:01 netbook kernel: [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
Sep 30 21:20:01 netbook kernel: render error detected, EIR: 0x00000010
Sep 30 21:20:01 netbook kernel: page table error
Sep 30 21:20:01 netbook kernel: PGTBL_ER: 0x00100113
Sep 30 21:20:02 netbook kernel: [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung

I've bisected it to this commit:

commit e259befd9013e212648c3bd4f6f1fbf92d0dd51d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Sep 17 00:32:02 2010 +0100

    drm/i915: Fix Sandybridge fence registers
    
    With 5 places to update when adding handling for fence registers, it is
    easy to overlook one or two. Correct that oversight, but fence
    management should be improved before a new set of registers is added.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug?id=30199
    Original patch by: Yuanhan Liu <yuanhan.liu@intel.com>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@kernel.org


hardware is:

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
        Subsystem: Giga-byte Technology Device 1999
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] Vendor Specific Information: Len=09 <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
        Subsystem: Giga-byte Technology Device 1999
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f2200000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at 18d0 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at f2300000 (32-bit, non-prefetchable) [size=256K]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-                                                                                          
        Capabilities: [d0] Power Management version 2                                                                                                       
        Kernel driver in use: i915                                                                                                                          
                                                                                                                                                            
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)                              
        Subsystem: Giga-byte Technology Device 1999                                                                                                         
        Flags: bus master, fast devsel, latency 0
        Memory at f2280000 (32-bit, non-prefetchable) [disabled] [size=512K]
        Capabilities: [d0] Power Management version 2

If more infos are needed, please tell me.

The errors always happend with an external display connected. I've booted the
system, logged in and changed the resolution to maximum of the external
display. Shortly after this the error happend.

regards,
  Johannes
