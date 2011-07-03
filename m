Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab1GCQiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 12:38:14 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:35625 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118Ab1GCQiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 12:38:11 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH v4 0/2] USB: EHCI: Allow users to override 80% max periodic bandwidth
Date: Sun,  3 Jul 2011 20:36:55 +0400
Message-Id: <cover.1309710420.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases, when 80% max isochronous bandwidth is too limiting.

Let's allow knowledgeable users to override that 80% max limit explicitly for
extreme cases, like 2 high bandwidth isochronously streaming devices on the
same High Speed USB bus in order to make them work simultaneously.

See full details in PATCH 2/2.


Changes since v3:

 - as suggested by Greg KH added new entry to Documentation/ABI/;

 - for consistency also touched Documentation/usb/ehci.txt reminding we now
   have new setting for periodic transfers scheduler.

   The base text in-there requires much updating regarding isochronous
   transfers, so only "TBD" with brief description was put because I'm not the best
   person to get EHCI description into shape;

 - added ACK to PATCH 2/2 from Alan Stern based on previous feedback. (I hope
   it's still semi-ok to put it, inspite of adding new not-reviewed text into
   docs);

 - minor cosmetics in patch descriptions.


Changes since v2:

 - changed the copyright in ehci-sysfs from David Brownell to Alan Stern;

 - added ACK to PATCH 1/2 from Alan Stern;

 - inspired by concerns raised by Sarah Sharp, added more details about testing
   done on N10 chipset, system stability, and that no-harm-is-done for those,
   who do not change uframe_periodic_max from default 100us;

 - when decreasing uframe_periodic_max, compare with the maximum number of
   microseconds already allocated for any uframe, instead of stopping as soon
   as it finds something above the new limit.


Changes since v1:

 - dropped RFC status as "this seems like the sort of feature somebody might
   reasonably want to use -- if they know exactly what they're doing";

 - new preparatory patch (1/2) which moves already-in-there sysfs code into
   ehci-sysfs.c;

 - moved uframe_periodic_max parameter from module option to sysfs attribute,
   so that it can be set per controller and at runtime, added validity checks;

 - clarified a bit bandwidth analysis for 96% max periodic setup as noticed by
   Alan Stern;

 - clarified patch description saying that set in stone 80% max periodic is
   specified by USB 2.0;

Kirill Smelkov (2):
  USB: EHCI: Move sysfs related bits into ehci-sysfs.c
  USB: EHCI: Allow users to override 80% max periodic bandwidth

 Documentation/ABI/testing/sysfs-module |   23 ++++
 Documentation/usb/ehci.txt             |    2 +
 drivers/usb/host/ehci-hcd.c            |   11 ++-
 drivers/usb/host/ehci-hub.c            |   75 -------------
 drivers/usb/host/ehci-sched.c          |   17 +--
 drivers/usb/host/ehci-sysfs.c          |  190 ++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci.h                |    2 +
 7 files changed, 233 insertions(+), 87 deletions(-)
 create mode 100644 drivers/usb/host/ehci-sysfs.c

-- 
1.7.6.rc3

