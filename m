Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1CUK4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:56:54 -0400
Received: from smtp.nokia.com ([147.243.1.47]:64636 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1CUK41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:56:27 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] usb: gadget: storage: Make CD-ROM emulation work with Mac OS-X
Date: Mon, 21 Mar 2011 12:59:16 +0200
Message-Id: <1300705159-24386-1-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mac OS-X expects CD-ROM TOC in raw format (i.e. format:2). It also
sends the READ_TOC CDB in old style SFF8020i format. i.e. 2 format bits
are encoded in MSBs of CDB byte 9.

The first patch introduces a fsg_get_toc() helper which builds the
Table of Contents (TOC) that can be used for the READ_TOC command.
The remaining two patches simply make file_storage gadget and mass_storage
gadget use the new helper function.

Changes in v2:
- Review comments incorporated.

---
Roger Quadros (3):
  usb: gadget: storage: Add fsg_get_toc helper
  usb: gadget: file_storage: Make CD-ROM emulation work with Mac OS-X
  usb: gadget: f_mass_storage: Make CD-ROM emulation work with Mac OS-X

 drivers/usb/gadget/f_mass_storage.c |   31 +++++++++-------
 drivers/usb/gadget/file_storage.c   |   31 +++++++++-------
 drivers/usb/gadget/storage_common.c |   68 +++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 26 deletions(-)

