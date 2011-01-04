Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1ADLAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:00:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49612 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1ADLAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:00:46 -0500
From: pavan_savoy@ti.com
To: padovan@profusion.mobi, marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [RFC 0/2] remove BT references from TI_ST
Date: Tue,  4 Jan 2011 04:59:46 -0600
Message-Id: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Gustavo,

Based on your comments, that the underlying shared transport driver
for btwilink driver made use of the BT references to peek into the packets
I have modified the TI_ST.

Since there lacks a generic way to parse the packets coming in from the
UART into BT, FM or GPS, we have to look into the data to fragment assembled
data or assemble fragmented data.
For this reason, Now the above lying protocol drivers like BT, FM and GPS
would send details about their packet types and header information which
would assist shared transport driver to parse the data.

Gustavo, please also notice the change in btwilink driver in and around,
st_register and suggest if something like this is OK.
btwilink can also be modified to send in all the packet specific data
in one shot, if that is preferred.

Please review and provide comments..

Note:
If this is alright, I will send out a modified patch with updated
subject to lkml/Greg for linux-next.

Thanks & Regards,
Pavan Savoy.

Pavan Savoy (2):
  drivers:misc:ti-st: change protocol parse logic
  Bluetooth: btwilink driver

 drivers/bluetooth/Kconfig    |   10 +
 drivers/bluetooth/Makefile   |    1 +
 drivers/bluetooth/btwilink.c |  397 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_core.c |  355 ++++++++++++--------------------------
 drivers/misc/ti-st/st_kim.c  |   56 +++---
 include/linux/ti_wilink_st.h |   40 +++--
 6 files changed, 575 insertions(+), 284 deletions(-)
 create mode 100644 drivers/bluetooth/btwilink.c

