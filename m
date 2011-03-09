Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1CIMTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:19:39 -0500
Received: from smtp.nokia.com ([147.243.1.47]:25402 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab1CIMTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:19:06 -0500
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] usb: gadget: storage: Make CD-ROM emulation work with Mac OS-X
Date: Wed,  9 Mar 2011 14:21:37 +0200
Message-Id: <1299673300-16726-1-git-send-email-roger.quadros@nokia.com>
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

---
Roger Quadros (3):
  usb: gadget: storage: Add fsg_get_toc helper
  usb: gadget: file_storage: Make CD-ROM emulation work with Mac OS-X
  usb: gadget: f_mass_storage: Make CD-ROM emulation work with Mac OS-X

 drivers/usb/gadget/f_mass_storage.c |   31 ++++++++------
 drivers/usb/gadget/file_storage.c   |   32 ++++++++------
 drivers/usb/gadget/storage_common.c |   79 +++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 26 deletions(-)

