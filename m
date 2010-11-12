Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab0KLGMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:12:20 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65006 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0KLGMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xtna+OoLh8rDVEkbgntTwJdErdhywue36vPG89uvlqtDRBBH8feDj//dyft6ocThUT
         b9Bbhzd4MndqrsVT0wPNgPH4V0IZr6t4zGv8gjTefo15suoTjg/WguisuGTF/ZK3hhdb
         8E01wbiBO6ea6f3KuclI/hN0utmqsV9Kk+qCY=
Date: Thu, 11 Nov 2010 22:12:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.37-rc1
Message-ID: <20101112061211.GA5096@core.coreip.homeip.net>
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

to receive updates for the input subsystem. Random driver fixes and
changes to make SysRq handler work better with KGDB. There will be
another change to SysRq handler to fix regression with not passing lone
Alt+SysRq and thus breaking print screen shortcut, but it is too young
to send it in this pull request.

Thanks!

Changelog:
---------

Axel Lin (1):
      Input: acecad - fix a memory leak in usb_acecad_probe error path

Benjamin LaHaise (1):
      Input: atkbd - add 'terminal' parameter for IBM Terminal keyboards

Dan Carpenter (1):
      Input: pcf8574_keypad - fix error handling in pcf8574_kp_probe

Dmitry Torokhov (3):
      Input: export input_reset_device() for use in KGDB
      kgdboc: reset input devices (keyboards) when exiting debugger
      Input: do not pass injected events back to the originating handler

Jesse Barnes (1):
      Input: i8042 - add Sony VAIOs to MUX blacklist

Michael Hennerich (1):
      Input: adp5588-keys - unify common header defines


Diffstat:
--------

 drivers/input/input.c                 |   87 +++++++++++++++++++++++----------
 drivers/input/keyboard/adp5588-keys.c |   74 +++++++++------------------
 drivers/input/keyboard/atkbd.c        |   12 ++++-
 drivers/input/misc/pcf8574_keypad.c   |   23 ++++-----
 drivers/input/serio/i8042-x86ia64io.h |   11 ++++
 drivers/input/tablet/acecad.c         |    3 +-
 drivers/serial/kgdboc.c               |   59 ++++++++++++++++++++++
 include/linux/i2c/adp5588.h           |   15 +++++-
 include/linux/input.h                 |    4 +-
 9 files changed, 196 insertions(+), 92 deletions(-)

-- 
Dmitry

