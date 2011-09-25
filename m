Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1IYU7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:59:09 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:53412
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab1IYU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:59:07 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Sep 2011 16:59:07 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p8PKmiIF007838
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: drm/i915: problems after closing/opening lid
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Sun, 25 Sep 2011 22:48:43 +0200
Message-ID: <gibou8tkk4.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Sun, 25 Sep 2011 22:48:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my Ideapad U160 I noticed a problem: after I close and reopen the
lid, Xorg behaves very strange.  For example:

* firefox seems to hang, switching tabs seems to not work but actually
  does after switching workspaces
* a menu in icewm that is displayed when changing window
  focusses behaves incorrect: either it doesn't show up or it doesn't
  visit every menu entry

This also happens after the display turns off after a while of
inactivity.  If I then change to a text console and back to Xorg,
everything is fine.

I bisected this to commit 9aa73a51c91cb0d0af4caaa9823969c1a1179a12.
I played with the params that were inverted in that commit and if I
change both or one of them via command line, there is no problem, the
problem only occurs if both of them have the new values.

I will also attach the relevant output of lspci.

Dirk

------------------------------------------------------------------------
commit 9aa73a51c91cb0d0af4caaa9823969c1a1179a12
Merge: c7c3694 a94919e
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Jul 12 10:40:25 2011 -0700

    Merge branch 'drm-intel-fixes' into drm-intel-next

diff --cc drivers/gpu/drm/i915/i915_drv.c
index 629d24c,eb91e2d..6ed73ae
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@@ -52,10 -52,10 +52,10 @@@ module_param_named(powersave, i915_powe
  unsigned int i915_semaphores = 0;
  module_param_named(semaphores, i915_semaphores, int, 0600);
  
- unsigned int i915_enable_rc6 = 1;
+ unsigned int i915_enable_rc6 = 0;
  module_param_named(i915_enable_rc6, i915_enable_rc6, int, 0600);
  
 -unsigned int i915_enable_fbc = 0;
 +unsigned int i915_enable_fbc = 1;
  module_param_named(i915_enable_fbc, i915_enable_fbc, int, 0600);
------------------------------------------------------------------------
$ lspci -vv
...
00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Lenovo Device 3920
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 1800 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4171
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915
        Kernel modules: i915
...
