Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1ALItc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:49:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab1ALItb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:49:31 -0500
Date: Wed, 12 Jan 2011 09:49:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
In-Reply-To: <alpine.LNX.2.00.1101080132020.26685@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1101112137310.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101080132020.26685@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Jan 2011, Jiri Kosina wrote:

> to receive first round of updates for the HID layer. There are quite a few 
> new devices supported (MacBook Air3 is probably the most notable one), as 
> well as a few random fixes here and there.
> 
> The second round, which will be following in a few days, will contain 
> first step towards unification of all the HID multitouch support (which is 
> currently scattered around into several distinct drivers). The few-day 
> delay is caused by (1) dependency on some input changes which are 
> currently in-flight your way (2) Benjamin performing some final testing of 
> the new unified driver right now.

Here goes the second round.

Please pull from 'for-linus' branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the first step of unification HID multitouch device drivers
into unified hid-multitouch driver.

The patchset adds support for a few new devices and migrates some of the 
ones which are currently supposed by various drivers into this unified 
driver.

This effort is targetted to be fully finalized in .39.

Thanks!



Benjamin Tissoires (8):
      HID: add feature_mapping callback
      HID: set HID_MAX_FIELD at 128
      HID: hid-multitouch: support for PixCir-based panels
      HID: hid-multitouch: add support for Cypress TrueTouch panels
      HID: hid-mulitouch: add support for the 'Sensing Win7-TwoFinger'
      HID: add Add Cando touch screen 10.1-inch product id
      HID: Switch turbox/mosart touchscreen to hid-mosart
      HID: hid-multitouch: minor fixes based on additional review

 drivers/hid/Kconfig             |   17 ++
 drivers/hid/Makefile            |    1 +
 drivers/hid/hid-cando.c         |    2 +
 drivers/hid/hid-core.c          |    7 +-
 drivers/hid/hid-ids.h           |    7 +
 drivers/hid/hid-input.c         |   17 +-
 drivers/hid/hid-mosart.c        |    1 +
 drivers/hid/hid-multitouch.c    |  516 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-quirks.c |    1 -
 include/linux/hid.h             |    6 +-
 10 files changed, 568 insertions(+), 7 deletions(-)
 create mode 100644 drivers/hid/hid-multitouch.c

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
