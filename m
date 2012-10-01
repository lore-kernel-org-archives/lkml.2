Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab2JAK0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:26:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33764 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2JAKZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:25:31 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/7] usb: dwc3-omap: add dt support
Date: Mon, 1 Oct 2012 15:55:00 +0530
Message-ID: <1349087107-18229-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds dt support to dwc3 core and fixes few minor
stuff in dwc3-omap glue to get dwc3 working.

While at that it also uses *of_platform* to create the child device
(dwc3-core) and fixes to use runtime API's to enable clock and write
to SYSCONFIG register.

Changes from v1:
* made device_for_each_child() as a seperate patch
* made all other minor fixes wrt typos and function renames

This patch series is developed on:
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git dwc3

Kishon Vijay Abraham I (7):
  usb: dwc3-omap: use device_for_each_child to handle child removal
  usb: dwc3-omap: use of_platform API to create dwc3 core pdev
  usb: dwc3-omap: use runtime API's to enable clocks
  usb: dwc3-omap: Remove explicit writes to SYSCONFIG register
  usb: dwc3-omap: Add an API to write to dwc mailbox
  usb: dwc3-omap: Minor fixes to get dt working
  usb: dwc3: core: add dt support for dwc3 core

 Documentation/devicetree/bindings/usb/dwc3.txt |   23 ++++
 drivers/usb/dwc3/core.c                        |   14 +-
 drivers/usb/dwc3/dwc3-omap.c                   |  167 +++++++++++++-----------
 include/linux/usb/dwc3-omap.h                  |   30 +++++
 4 files changed, 158 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/dwc3.txt
 create mode 100644 include/linux/usb/dwc3-omap.h

-- 
1.7.9.5

