Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1ALNWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:22:05 -0500
Received: from mail.nusquama.org ([85.131.211.20]:32907 "EHLO
	mail.nusquama.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932388Ab1ALNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:21:53 -0500
From: Max Vozeler <max@vozeler.com>
To: gregkh@suse.de
Cc: hirofuchi@users.sourceforge.net, rpjday@crashcourse.ca,
        bgmerrell@novell.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mwehby@luxotticaRetail.com,
        marco@optikam.com, Max Vozeler <max@vozeler.com>
Subject: [PATCH 0/7] staging/usbip fixes
Date: Wed, 12 Jan 2011 15:01:58 +0200
Message-Id: <1294837325-26187-1-git-send-email-max@vozeler.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are fixes for problems found testing usbip in a 
larger setup with up to 13 devices attached at the same
time (we changed VHCI_NPORTS for the tests).

Review of the usb reference counting changes would be 
much appreciated. 

The change handling EAGAIN from connection timeouts set
with SO_RCVTIMEO is admittedly not pretty, but the best we
can do without breaking the protocol.

Max Vozeler (7):
  staging: usbip: stub: update refcounts for devices and interfaces
  staging: usbip: vhci: update reference count for usb_device
  staging: usbip: vhci: give back URBs from in-flight unlink requests
  staging: usbip: vhci: refuse to enqueue for dead connections
  staging: usbip: vhci: friendly log messages for connection errors
  staging: usbip: vhci: handle EAGAIN from SO_RCVTIMEO
  staging: usbip: vhci: use urb->dev->portnum to find port

 drivers/staging/usbip/stub.h     |    1 +
 drivers/staging/usbip/stub_dev.c |   18 ++++++++++---
 drivers/staging/usbip/stub_rx.c  |    4 +-
 drivers/staging/usbip/vhci.h     |    6 ++--
 drivers/staging/usbip/vhci_hcd.c |   54 ++++++++++++++++++++++++++++++++-----
 drivers/staging/usbip/vhci_rx.c  |   50 +++++++++++++++++++++++++++++-----
 6 files changed, 108 insertions(+), 25 deletions(-)

-- 
1.7.2.3

