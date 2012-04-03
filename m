Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab2DCHEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:04:20 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:57828 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2DCHET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:04:19 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsY9AIegek9V5qnhPGdsb2JhbABFt3gZAQEBATc0ghECUyMYEWARChouh3IHumsTkFsEkzaIKo0Z
X-IronPort-AV: E=Sophos;i="4.75,362,1330902000"; 
   d="scan'208";a="79869352"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [RFC 0/5] hid: Extending the device-driver matching mechanism
Date: Tue,  3 Apr 2012 09:05:25 +0200
Message-Id: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

These patches were first sent out as a reply to Benjamin's autoloading
patch (http://www.spinics.net/lists/linux-input/msg20001.html), but it
seems more appropriate as an RFC.

The idea is to parse the hid descriptors before adding the device,
such that the device identifier, in particular the device/modalias,
can be augmented by the report information. This approach solves the
generic auto-loading problem we face today, here exemplified by a
solution for hid-multitouch.

The patches apply cleanly to 3.3 for easy testing.

Thanks,
Henrik

Henrik Rydberg (5):
  hid: Remove multitouch quirk
  hid-multitouch: Prepare driver for new device ids
  hid: Parse the device before adding it
  hid: Add idtags to modalias
  hid: Remove multitouch devices from blacklist

 drivers/hid/hid-core.c          |   88 ++++++++-------------------
 drivers/hid/hid-input.c         |   11 ----
 drivers/hid/hid-multitouch.c    |  124 +++++++++++++++++++++------------------
 drivers/hid/usbhid/hid-core.c   |    5 ++
 include/linux/hid.h             |    8 ++-
 include/linux/mod_devicetable.h |    2 +-
 scripts/mod/file2alias.c        |    2 +
 7 files changed, 107 insertions(+), 133 deletions(-)

-- 
1.7.9.5

