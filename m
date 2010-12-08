Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0LHFdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:33:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64110 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0LHFdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BeYKFcNOHARTelQpRJNkbUrgvkqvw1AGNG3o5cMZlBIdCtQl4aGde+b5JrMkGgOthM
         e8mxvOudFLZMYZidufr3c/2eKsCdNXOSuSQ7hqn5AXx57dztSGZ2XRbVTR0rw/mPqsIQ
         aliJRldtLyfwnO0Y9DohmuzYZJclflGVXPJHw=
Date: Tue, 7 Dec 2010 21:33:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.37-rc5
Message-ID: <20101208053316.GC4140@core.coreip.homeip.net>
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

to receive updates for the input subsystem.

Mostly small fixups: new device IDs for wacom and usbtouchscreen
drivers, fix for 2-button Synaptics Clickpad handling and documentation
updates.

But I am also sending along a new driver for polled GPIO button. The
reason I am sending it now is to ease merging arch code in .38 merge
window. Since it is a platform driver and there are no corresponding
devices in the tree yet, it is not going to be loaded and used even if
someone ends up enabling it and so should be safe to merge even though
we are getting nearer release.

Thanks!

Changelog:
---------

Bastien Nocera (1):
      Input: add keycodes for touchpad on/off keys

David Foley (2):
      Input: wacom - add IDs for two new Bamboo PTs
      Input: wacom - add new Bamboo PT (0xdb)

Dmitry Torokhov (1):
      Input: document struct input_absinfo

Gabor Juhos (1):
      Input: add input driver for polled GPIO buttons

Glenn Sommer (1):
      Input: usbtouchscreen - add support for LG Flatron T1710B

Namhyung Kim (1):
      Input: turbografx - fix reference counting

Yan Li (1):
      Input: synaptics - fix handling of 2-button ClickPads


Diffstat:
--------

 drivers/input/joystick/turbografx.c        |    1 +
 drivers/input/keyboard/Kconfig             |   16 ++
 drivers/input/keyboard/Makefile            |    1 +
 drivers/input/keyboard/gpio_keys_polled.c  |  261 ++++++++++++++++++++++++++++
 drivers/input/mouse/synaptics.h            |    3 +-
 drivers/input/tablet/wacom_wac.c           |    9 +
 drivers/input/touchscreen/usbtouchscreen.c |    1 +
 include/linux/gpio_keys.h                  |    2 +
 include/linux/input.h                      |   25 +++-
 9 files changed, 317 insertions(+), 2 deletions(-)
 create mode 100644 drivers/input/keyboard/gpio_keys_polled.c

-- 
Dmitry

