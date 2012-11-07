Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2KGQh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:37:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56660 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:37:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/13] Win 8 support for digitizers
Date: Wed,  7 Nov 2012 17:37:23 +0100
Message-Id: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

here is the third version of this patchset.
I think I included most of Henrik's comments.

Happy reviewing :)

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

Benjamin Tissoires (13):
  HID: hid-input: export hidinput_calc_abs_res
  HID: hid-input: round return value of hidinput_calc_abs_res
  HID: core: fix unit exponent parsing
  HID: hid-input: add usage_index in struct hid_usage.
  HID: hid-multitouch: support arrays for the split of the touches in a
    report
  HID: hid-multitouch: get maxcontacts also from logical_max value
  HID: hid-multitouch: support T and C for win8 devices
  HID: hid-multitouch: move ALWAYS_VALID quirk check
  HID: hid-multitouch: add MT_QUIRK_IGNORE_DUPLICATES
  HID: hid-multitouch: fix Win 8 protocol
  HID: hid-multitouch: support for hovering devices
  HID: introduce Scan Time
  HID: hid-multitouch: forwards ABS_SCAN_TIME

 Documentation/input/event-codes.txt |   9 +++
 drivers/hid/hid-core.c              |  20 ++++-
 drivers/hid/hid-input.c             |  28 +++++--
 drivers/hid/hid-multitouch.c        | 157 ++++++++++++++++++++++++++++++------
 include/linux/hid.h                 |   4 +
 include/linux/input.h               |   1 +
 include/linux/input/mt.h            |   6 ++
 7 files changed, 192 insertions(+), 33 deletions(-)

-- 
1.7.11.7

