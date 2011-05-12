Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1ELQtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:49:20 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:25329 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758044Ab1ELQtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:49:14 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.39 regression] i915/kms: garbled screen because of 49183b281  (was: Re: Linux 2.6.39-rc7)
Date: Thu, 12 May 2011 18:49:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
References: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
In-Reply-To: <BANLkTi=9fGdBw=r_dDE3KSPfjU0UjXBZFw@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121849.09225@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds -- Tuesday 10 May 2011:
> But please do test, just to make sure that 39-final is good.

> Chris Wilson (4):
>       drm/i915: Only enable the plane after setting the fb base (pre-ILK)

This patch introduces a bug on my infamous "Acer Travelmate
5735Z-452G32Mnss": when KMS takes over, the frame buffer contents
get completely garbled up on screen, with colored stripes and
unreadable text (photo on request). Only when X11 is started, the
screen gets restored again. Closing and re-opening the lid partly
cures the mess, too: it makes the font readable, though horizontally
stretched.

Reverting 49183b2818de6899383bb82bc032f9344d6791ff fixes the
bug.

m.





drm.debug=0x02

[    2.604831] [drm] Initialized drm 1.1.0 20060810
[    2.648409] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.648415] i915 0000:00:02.0: setting latency timer to 64
[    2.708949] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7ba8c018
[    2.708987] [drm:intel_opregion_setup], Public ACPI methods supported
[    2.708989] [drm:intel_opregion_setup], SWSCI supported
[    2.708991] [drm:intel_opregion_setup], ASLE supported
[    2.709047] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    2.709053] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.709054] [drm] Driver supports precise vblank timestamp query.
[    2.735626] [drm:init_status_page], render ring hws offset: 0x00000000
[    2.735747] [drm:init_status_page], bsd ring hws offset: 0x00021000
[    2.735852] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[    2.779279] [drm:intel_panel_get_backlight], get backlight PWM = 0
[    2.779287] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.779616] [drm:intel_panel_set_backlight], set backlight PWM = 0
[    2.779619] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    2.779626] [drm:intel_opregion_asle_intr], non asle set request??
[    3.022059] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe A
[    3.022065] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe A
[    3.074270] checking generic (80000000 3ff0000) vs hw (80000000 10000000)
[    3.074274] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[    3.074293] Console: switching to colour dummy device 80x25
[    3.074806] fbcon: inteldrmfb (fb0) is primary device
[    3.109085] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.109087] [drm:intel_panel_set_backlight], set backlight PWM = 736950
[    3.109090] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[    3.109098] [drm:intel_opregion_asle_intr], non asle set request??
[    3.109111] Console: switching to colour frame buffer device 170x48
[    3.111779] fb0: inteldrmfb frame buffer device
[    3.111780] drm: registered panic notifier
[    3.158015] scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    3.413081] acpi device:07: registered as cooling_device2
[    3.413431] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input6
[    3.413532] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
[    3.413982] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    4.059019] sd 4:0:0:0: [sdb] 15720448 512-byte logical blocks: (8.04 GB/7.49 GiB)
[    4.059746] sd 4:0:0:0: [sdb] Write Protect is off
[    4.059750] sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    4.059752] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    4.061879] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    4.066269]  sdb: sdb1
[    4.067995] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    4.068056] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    5.016884] md: linear personality registered for level -1
[   94.800469] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[   94.800473] [drm:intel_panel_set_backlight], set backlight PWM = 72250
[   94.800477] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
[   94.800482] [drm:intel_opregion_asle_intr], non asle set request??
[   94.800485] [drm:intel_opregion_asle_intr], non asle set request??
