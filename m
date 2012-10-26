Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2JZIok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:44:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62909 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2JZIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:37 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/11] Win 8 support for digitizers
Date: Fri, 26 Oct 2012 10:44:16 +0200
Message-Id: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Ok, now, it should work with Jiri's tree.

v1 introduction:
So, this is an update for supporting Win 8 multitouch devices in the kernel.
As I wanted to reliably forward the resolution, I noticed a bug in the
processing of the unit_exponent in the hid core layer.
Thus the fixes for hid-core and hid-input.

v2 changes:
* added missing initial patch that prevents the series to be applied on top of Jiri's tree
* update to include latest hid changes
* taken into account Alan's patch: "hid: put the case in the right switch statement"

Sorry for the noise...

Cheers,
Benjamin

---

Benjamin Tissoires (11):
  HID: hid-input: export hidinput_calc_abs_res
  HID: core: fix unit exponent parsing
  HID: hid-input: add usage_index argument in input_mapping and event.
  HID: hid-multitouch: support arrays for the split of the touches in a
    report
  HID: hid-multitouch: get maxcontacts also from logical_max value
  HID: hid-multitouch: support T and C for win8 devices
  HID: hid-multitouch: move ALWAYS_VALID quirk check
  HID: hid-multitouch: fix Win 8 protocol
  HID: hid-multitouch: support for hovering devices
  HID: introduce Scan Time
  HID: hid-multitouch: get rid of usbhid depedency for general path

 Documentation/input/event-codes.txt |   7 ++
 drivers/hid/hid-a4tech.c            |   2 +-
 drivers/hid/hid-apple.c             |   4 +-
 drivers/hid/hid-belkin.c            |   2 +-
 drivers/hid/hid-cherry.c            |   2 +-
 drivers/hid/hid-chicony.c           |   2 +-
 drivers/hid/hid-core.c              |  26 +++--
 drivers/hid/hid-cypress.c           |   2 +-
 drivers/hid/hid-ezkey.c             |   4 +-
 drivers/hid/hid-gyration.c          |   4 +-
 drivers/hid/hid-input.c             |  44 ++++++---
 drivers/hid/hid-kensington.c        |   2 +-
 drivers/hid/hid-lcpower.c           |   2 +-
 drivers/hid/hid-lenovo-tpkbd.c      |   3 +-
 drivers/hid/hid-lg.c                |   4 +-
 drivers/hid/hid-magicmouse.c        |   3 +-
 drivers/hid/hid-microsoft.c         |   4 +-
 drivers/hid/hid-monterey.c          |   2 +-
 drivers/hid/hid-multitouch.c        | 191 ++++++++++++++++++++++++++----------
 drivers/hid/hid-ntrig.c             |   4 +-
 drivers/hid/hid-petalynx.c          |   2 +-
 drivers/hid/hid-prodikeys.c         |   2 +-
 drivers/hid/hid-ps3remote.c         |   3 +-
 drivers/hid/hid-samsung.c           |   2 +-
 drivers/hid/hid-speedlink.c         |   6 +-
 drivers/hid/hid-sunplus.c           |   2 +-
 drivers/hid/hid-tivo.c              |   2 +-
 drivers/hid/hid-topseed.c           |   2 +-
 drivers/hid/hid-twinhan.c           |   2 +-
 drivers/hid/hid-zydacron.c          |   2 +-
 include/linux/hid.h                 |   8 +-
 include/linux/input.h               |   1 +
 32 files changed, 244 insertions(+), 104 deletions(-)

-- 
1.7.11.7

