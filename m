Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab0DWIDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:03:10 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50387 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] m68k: amiga - device model patches
Date: Fri, 23 Apr 2010 10:00:21 +0200
Message-Id: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches brings Amiga hardware support better in line with the
Linux device model:
 - Add module alias support for Zorro drivers (not all drivers can
   benefit from this yet though, as some still use zorro_find_device()
   instead of struct zorro_driver),
 - Convert the various builtin Amiga hardware to the platform driver
   framework.

[01] platform: Make platform resources input parameters const
[02] m68k: amiga - Zorro bus modalias support
[03] m68k: amiga - Zorro host bridge platform device conversion
[04] m68k: amiga - Frame buffer platform device conversion
[05] m68k: amiga - Sound platform device conversion
[06] m68k: amiga - Floppy platform device conversion
[07] m68k: amiga - A3000 SCSI platform device conversion
[08] m68k: amiga - A4000T SCSI platform device conversion
[09] m68k: amiga - Amiga Gayle IDE platform device conversion
[10] m68k: amiga - Keyboard platform device conversion
[11] m68k: amiga - Mouse platform device conversion
[12] m68k: amiga - Serial port platform device conversion
[13] m68k: amiga - Parallel port platform device conversion
[14] rtc: Add an RTC driver for the Oki MSM6242
[15] rtc: Add an RTC driver for the Ricoh RP5C01
[16] m68k: amiga - RTC platform device conversion

It's a respin of the RFC I sent one year ago. The only real change is to the
A3000 SCSI platform device conversion patch, which now depends on the wd33c93
driver cleanups patches I sent 2.5 weeks ago.

Due to lack of hardware (only Amiga 4000 here), I couldn't test all drivers.
Especially the SCSI drivers could use some testing feedback.
The changes to most other drivers are fairly trivial.
Note that I removed all request_mem_region() calls for subregions of the Amiga
custom chips, as the drivers now bind to the platform device.

If no one objects, I'm gonna apply all of this.

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
