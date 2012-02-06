Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2BFP35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:29:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab2BFP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:29:56 -0500
Date: Mon, 6 Feb 2012 16:29:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1202061621430.24127@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive fixes for -rc3.

- fix for crashing wacom driver due to incorrect ordering of 
  power_supply_* calls; I had to merge your tree into upstream-fixes
  branch first, in order to have the buggy code that went in through
  Anton's tree
- deadlock / race fix in generic USB HID code between open() and 
  disconnect() (caught by lockdep, not usually triggered in the wild)
- fix for hyperv driver to handle disconnection of corresponding input 
  device properly


K. Y. Srinivasan (1):
      HID: hyperv: Properly disconnect the input device

Ming Lei (1):
      HID: usbhid: fix dead lock between open and disconect

Przemo Firszt (1):
      HID: wacom: Fix invalid power_supply_powers calls

 drivers/hid/hid-hyperv.c    |    1 +
 drivers/hid/hid-wacom.c     |    7 ++++---
 drivers/hid/usbhid/hiddev.c |    4 ++--
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
Jiri Kosina
SUSE Labs
