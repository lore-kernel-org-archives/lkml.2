Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1FXQtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:49:14 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:38226 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1FXQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:49:11 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH v2 0/2] USB: EHCI: Allow users to override 80% max periodic bandwidth
Date: Fri, 24 Jun 2011 20:48:06 +0400
Message-Id: <cover.1308933456.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v1:


 - dropped RFC status as "this seems like the sort of feature somebody might
   reasonably want to use -- if they know exactly what they're doing";

 - new preparatory patch (1/2) which moves already-in-there sysfs code into
   ehci-sysfs.c;

 - moved uframe_periodic_max parameter from module option to sysfs attribute,
   so that it can be set per controller and at runtime, added validity checks;

 - clarified a bit bandwith analysis for 96% max periodic setup as noticed by
   Alan Stern;

 - clarified patch description saying that set in stone 80% max periodic is
   specified by USB 2.0;

Kirill Smelkov (2):
  USB: EHCI: Move sysfs related bits into ehci-sysfs.c
  USB: EHCI: Allow users to override 80% max periodic bandwidth

 drivers/usb/host/ehci-hcd.c   |   11 ++-
 drivers/usb/host/ehci-hub.c   |   75 -----------------
 drivers/usb/host/ehci-sched.c |   17 ++--
 drivers/usb/host/ehci-sysfs.c |  184 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci.h       |    2 +
 5 files changed, 202 insertions(+), 87 deletions(-)
 create mode 100644 drivers/usb/host/ehci-sysfs.c

-- 
1.7.6.rc3

