Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0LCBYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:24:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:46579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab0LCBYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:24:52 -0500
Date: Fri, 3 Dec 2010 02:24:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1012030210200.14806@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from 'for-linus' branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID subsystem that should be in 2.6.37.

The most important one is a fix from Dmitry. We don't want to do a major 
release with wrong units being exported, as that would be bad ABI issue in 
evdev.
The rest is just very simple fixes and device ID addition.

Note: you are going to get conflict in drivers/hid/hid-input.c. This is 
caused by commit a0bf0ea8 ("Input: hid-input - switch to using new keycode 
interface") which went through Dmitry's tree, as it was part of larger 
rework. It's fine to just use the variant from that commit. I'd normally 
pull your tree into the 'for-linus' branch and resolve the conflict 
myself, but as you explicitly asked last time (and on KS I believe as 
well) not to do it, I am keeping the conflict resolution there for you :)

Thanks!



Dmitry Torokhov (1):
      HID: length resolution should be reported units/mm

Henrik Rydberg (1):
      HID: egalax: Use kzalloc

Joe Perches (1):
      HID: Remove KERN_DEBUG from dbg_hid use

Simon Wood (1):
      HID: add support for F430 Force Feedback Wheel

 drivers/hid/hid-core.c   |    1 +
 drivers/hid/hid-egalax.c |    2 +-
 drivers/hid/hid-input.c  |   22 +++++++++++++---------
 drivers/hid/hid-tmff.c   |    2 ++
 4 files changed, 17 insertions(+), 10 deletions(-)
