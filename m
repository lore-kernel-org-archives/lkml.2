Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161142Ab2KNP7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:59:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43778 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2KNP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:59:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/14] Win 8 support for digitizers
Date: Wed, 14 Nov 2012 16:59:12 +0100
Message-Id: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

here is the forth version of this patchset.

* patches 1-9 has already been reviewed and are ready for inclusion I would say.
* Jiri, I kept your ack on patch 4 even if I changed the place of the comment in hid.h
* patch 10 is half new as it is splitted from a patch of the v3
* patch 11 has been changed according to Henrik's comments
* patches 12-13 have been splitted since v3 to introduce QUIRK_HOVERING and setup WIN 8
devices in a better way.
* patch 14 has been copied from the v3 as Dmitry wanted to use a MSC event for the timestamp.

Cheers,
Benjamin

v1 introduction:
So, this is an update for supporting Win 8 multitouch devices in the kernel.
As I wanted to reliably forward the resolution, I noticed a bug in the
processing of the unit_exponent in the hid core layer.
Thus the fixes for hid-core and hid-input.

v2 changes:
* added missing initial patch that prevents the series to be applied on top of Jiri's tree
* update to include latest hid changes
* taken into account Alan's patch: "hid: put the case in the right switch statement"

v3 changes:
* splitted "round return value of hidinput_calc_abs_res" in a separate patch
* export snto32 in hid.h as we need to use it in hid-input.c
* didn't change all drivers, but add a field in hid_usage instead
* add quirk MT_QUIRK_IGNORE_DUPLICATES so that any device can rely on it
* easier understandable support of hovering devices
* changed scan time definition
* applied new definition of scan time in hid-multitouch
* some other few things.

v4 changes:
* introduced QUIRK_HOVERING for hovering devices (not necessarily win 8 ones)
* removed QUIRK_WIN8_CERTIFIED as it's not relevant anymore
* made the change in input-mt.c
* add a test against input->mt != null

Benjamin Tissoires (14):
  HID: hid-input: export hidinput_calc_abs_res
  HID: hid-input: round return value of hidinput_calc_abs_res
  HID: core: fix unit exponent parsing
  HID: hid-input: add usage_index in struct hid_usage.
  HID: hid-multitouch: support arrays for the split of the touches in a
    report
  HID: hid-multitouch: get maxcontacts also from logical_max value
  HID: hid-multitouch: support T and C for win8 devices
  HID: hid-multitouch: move ALWAYS_VALID quirk check
  Input: introduce EV_MSC Timestamp
  Input: mt: add input_mt_is_used
  HID: hid-multitouch: add MT_QUIRK_IGNORE_DUPLICATES
  HID: hid-multitouch: support for hovering devices
  HID: hid-multitouch: fix Win 8 protocol
  HID: hid-multitouch: forwards MSC_TIMESTAMP

 Documentation/input/event-codes.txt |  11 +++
 drivers/hid/hid-core.c              |  20 ++++-
 drivers/hid/hid-input.c             |  24 ++++--
 drivers/hid/hid-multitouch.c        | 155 ++++++++++++++++++++++++++++++------
 drivers/input/input-mt.c            |   2 +-
 include/linux/hid.h                 |   4 +
 include/linux/input.h               |   1 +
 include/linux/input/mt.h            |   6 ++
 8 files changed, 191 insertions(+), 32 deletions(-)

-- 
1.8.0

