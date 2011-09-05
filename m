Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1IECOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:14:43 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:4045 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1IECOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:14:37 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH v5 0/8] Input: elantech: add support for newer hardware
Date: Mon,  5 Sep 2011 10:16:39 +0800
Message-Id: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lists,

This is a series of patches to add support for newer generations of ELAN
touchpad.

Patches #1~#6 are essentially fixes and cleanups that pave the way for
patch #7 and patch #8, which really adds code for v3 and v4 hardware.

Any comments, suggestoins are welcome.

Please take a look at patch #8, which adds support for the latest touchpads from ELAN.
It is a true multi-touch capable touchpad that can track up to 5 fingers.
Support is implemented using MT-B protocol. I used synaptics and multitouch X
driver to test this driver, both worked fine.

Thank you very much.

Changes since v1:
- drop EC workaround patch.
- add patch #2, make ST and MT have the same range, as Dmitry suggested.
- add patch #4, remove ETP_EDGE_FUZZ_V2, as Éric suggested.
- rename all packet checking functions so they are consistent.
- some code cleanup, and don't report ABS_[XY] when fingers == 0, as Seth suggested.
- add document for v3 debounce, and now check debounce in elantech_packet_check_v3.

Changes since v2:
- fix v3 hardware packet checking (reported by Seth and fix by Dmitry.)

Changes since v3:
- fix a tiny style problem (useless space on end-of-line, reported by Seth)
- v3 hardware can track 2 fingers well, so do not set INPUT_PROP_SEMI_MT on v3
  (As suggested earlier by Éric.)
- add patch #8, which adds support for v4 hardware.

Changes since v4:
- patch #8: fix a typo (pressure, spotted by Éric)
- patch #8: add _v4 suffix for functions introduced in this patch (suggested by Éric)
- patch #8: simplify set_range switch for case 3 and case 4 (suggested by Éric)

JJ Ding (8):
  Input: elantech - correct x, y value range for v2 hardware
  Input: elantech - get rid of ETP_2FT_* in elantech.h
  Input: elantech - use firmware provided x, y ranges
  Input: elantech - remove ETP_EDGE_FUZZ_V2
  Input: elantech - packet checking for v2 hardware
  Input: elantech - clean up elantech_init
  Input: elantech - add v3 hardware support
  Input: elantech - add v4 hardware support

 Documentation/input/elantech.txt |  295 +++++++++++++++++-
 drivers/input/mouse/elantech.c   |  615 +++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/elantech.h   |   56 +++-
 3 files changed, 860 insertions(+), 106 deletions(-)

-- 
1.7.4.1

