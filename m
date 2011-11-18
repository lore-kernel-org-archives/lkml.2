Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1KRAVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:21:02 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62720 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1KRAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:21:00 -0500
Date: Fri, 18 Nov 2011 01:20:49 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: anaghi@mail.gnudd.com, balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: [PATCH V2 0/2] debugfs: a tool to print 32-bit registers
Message-ID: <20111118002049.GA24806@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is V2 of what I posted a few days ago. I also updates
the file in Documentation.  I Cc:d people who gave feedback.

Patch 2 uses the new tool for an existing file I didn't initially
notice (I had a victim file, but it's seriously failing compilation).
Code removal there is almost zero because Felipe Balbi already did
stuff in the way I do.

Mark Brown suggested to look at drivers/base/regmap, and actually this
may be duplicating what is already being worked on in a more general
way. My code base is earlier than regmap so I didn't notice.
Unfortunately I have no resources left to study regmap as it
deserves.

Mark, if you say this is not useful at this point, I'm fine with it; I
may return with some regbase-aware code when time permits if it's not
already there.

/alessandro

Alessandro Rubini (2):
  debugfs: add tools to printk 32-bit registers
  usb: dwc3: use debugfs_print_regs32()

 Documentation/filesystems/debugfs.txt |   32 +++++++++++-
 drivers/usb/dwc3/debugfs.c            |   15 +----
 fs/debugfs/file.c                     |   90 +++++++++++++++++++++++++++++++++
 include/linux/debugfs.h               |   26 +++++++++
 4 files changed, 150 insertions(+), 13 deletions(-)
