Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1DEO5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:57:41 -0400
Received: from smtp.nokia.com ([147.243.1.48]:57616 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab1DEO5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:57:02 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, sshtylyov@mvista.com, mina86@mina86.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v3 0/3] Make CD-ROM emulation work with Mac OS-X
Date: Tue,  5 Apr 2011 17:59:26 +0300
Message-Id: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please accept these patches if no more comments. Thanks.

Mac OS-X expects CD-ROM TOC in raw format (i.e. format:2). It also
sends the READ_TOC CDB in old style SFF8020i format. i.e. 2 format bits
are encoded in MSBs of CDB byte 9.

The first patch introduces a fsg_get_toc() helper which builds the
Table of Contents (TOC) that can be used for the READ_TOC command.
The remaining two patches simply make file_storage gadget and mass_storage
gadget use the new helper function.

Changes in v3:
- return length fixed for fsg_get_toc()

Changes in v2:
- Review comments incorporated.

---
Roger Quadros (3):
  usb: gadget: storage: Add fsg_get_toc helper
  usb: gadget: file_storage: Make CD-ROM emulation work with Mac OS-X
  usb: gadget: f_mass_storage: Make CD-ROM emulation work with Mac OS-X

 drivers/usb/gadget/f_mass_storage.c |   31 ++++++++++-------
 drivers/usb/gadget/file_storage.c   |   31 ++++++++++-------
 drivers/usb/gadget/storage_common.c |   65 +++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 26 deletions(-)

