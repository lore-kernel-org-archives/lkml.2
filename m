Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0HRWAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:00:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:44074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0HRWAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:00:06 -0400
Date: Thu, 19 Aug 2010 00:00:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1008181422210.1019@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID fixes below. The most important is the memory corruption 
fix in hiddev, which was caused by Arnd's patch that tried to get rid of 
BKL, but messed up intf private data. It's verified to fix various bug 
reports (warnings from kobject core code, suspend-resume failures, etc).

Apart from that, a few minor fixes in picolcd driver and a device ID 
addition.

Thanks.

Bruno Prémont (1):
      HID: picolcd: correct ordering of framebuffer freeing

Chris Ball (2):
      HID: hiddev: protect against disconnect/NULL-dereference race
      USB HID: Add ID for eGalax Multitouch used in JooJoo tablet

Dan Carpenter (1):
      HID: picolcd: testing the wrong variable

Jiri Kosina (1):
      HID: hiddev: fix memory corruption due to invalid intfdata

 drivers/hid/hid-core.c      |    1 +
 drivers/hid/hid-egalax.c    |    9 +++++++++
 drivers/hid/hid-ids.h       |    1 +
 drivers/hid/hid-picolcd.c   |    4 ++--
 drivers/hid/usbhid/hiddev.c |   11 +++++++----
 5 files changed, 20 insertions(+), 6 deletions(-)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
