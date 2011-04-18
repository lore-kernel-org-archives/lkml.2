Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1DRRXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:23:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39380 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1DRRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vFS+gfbJP3LKOzxQzqmHhFAcFtv53pWhhMnE47apJrYqXiYnmAbPSzpBMo/gOQsa+m
         NcuPL4RwwaNOt10ieXtqwv+Wb53b51kkq9HcXS/cGx8v4SfcqcQMKV+IeSP+hbdKOjLF
         KBy7BzIq6cToNDHZLpdDELcs9qCr8D9y3En/Q=
Date: Mon, 18 Apr 2011 10:23:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.39-rc3
Message-ID: <20110418172301.GA14259@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Couple of driver fixes plus
changes to evdev to signal buffer overruns to userspace and also change
to input core to estimate number of events in a packet (mostly useful
for multitouch devices).

Changelog:
---------

Axel Lin (1):
      Input: twl4030_keypad - fix potential NULL dereference in twl4030_kp_probe()

Chase Douglas (1):
      Input: document event types and codes and their intended use

Christoph Fritz (1):
      Input: h3600_ts - fix error handling at connect

Igor Mammedov (1):
      Input: xen-kbdfront - fix mouse getting stuck after save/restore

Jarod Wilson (1):
      Input: add KEY_IMAGES specifically for AL Image Browser

Jeff Brown (2):
      Input: evdev - indicate buffer overrun with SYN_DROPPED
      Input: estimate number of events per packet

Shubhrajyoti D (1):
      Input: twl4030_keypad - avoid potential NULL-pointer dereference


Diffstat:
--------

 Documentation/input/event-codes.txt        |  262 ++++++++++++++++++++++++++++
 drivers/input/evdev.c                      |   33 +++--
 drivers/input/input.c                      |   40 +++++
 drivers/input/keyboard/twl4030_keypad.c    |    6 +-
 drivers/input/misc/xen-kbdfront.c          |   13 ++-
 drivers/input/touchscreen/h3600_ts_input.c |   17 +-
 include/linux/input.h                      |   10 +-
 include/linux/input/mt.h                   |    6 +
 8 files changed, 361 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/input/event-codes.txt

-- 
Dmitry

