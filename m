Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0HZH1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:27:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0HZH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=itXS8LqZse82KWA3ZZ+dpyECaCpS2JiQ0R3nQZihm2xpPbms5bpCGZz5IMzFaV/smZ
         9xNyv5cUYZpUUcK9Q06vAB2nQwo6hGQrtFzSdjFGmQbjyRHqXnNtJnEYt2AvZK00t03S
         DTQIrffjHOgo2SIHkT02Ld6M0ISFk1YVslSzY=
Date: Thu, 26 Aug 2010 00:27:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.36-rc2
Message-ID: <20100826072731.GC7788@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. The changes consist of
couple bug/regression fixes and also 3 patches dropping 'tty' argument
from SysRq handlers. While the last 3 are not bug fixes I mentioned that
I would be sending them in my -rc0 pull request and so I hope they could
still make it in (I did not send them with rc0 pull request because there
were conflicts and I waited for -rc1 to merge and resolve).

Thanks,

Changelog:
---------

Axel Lin (1):
      Input: pxa27x_keypad - remove input_free_device() in pxa27x_keypad_remove()

Christoph Fritz (1):
      Input: mousedev - fix regression of inverting axes

Dmitry Torokhov (4):
      Input: sysrq - drop tty argument from sysrq ops handlers
      Input: sysrq - drop tty argument form handle_sysrq()
      USB: drop tty argument from usb_serial_handle_sysrq_char()
      Input: hil_kbd - fix compile error

Kay Sievers (1):
      Input: uinput - add devname alias to allow module on-demand load


Diffstat:
--------

 arch/arm/kernel/etm.c                  |    2 +-
 arch/ia64/hp/sim/simserial.c           |    2 +-
 arch/powerpc/xmon/xmon.c               |    5 +--
 arch/sparc/kernel/process_64.c         |    2 +-
 arch/um/drivers/mconsole_kern.c        |    2 +-
 drivers/char/hangcheck-timer.c         |    2 +-
 drivers/char/hvc_console.c             |    2 +-
 drivers/char/hvsi.c                    |    2 +-
 drivers/char/sysrq.c                   |   53 +++++++++++++++----------------
 drivers/gpu/drm/drm_fb_helper.c        |    2 +-
 drivers/input/keyboard/hil_kbd.c       |   12 +++---
 drivers/input/keyboard/pxa27x_keypad.c |    2 -
 drivers/input/misc/uinput.c            |    2 +
 drivers/input/mousedev.c               |    8 ++--
 drivers/net/ibm_newemac/debug.c        |    2 +-
 drivers/s390/char/ctrlchar.c           |    4 +--
 drivers/s390/char/keyboard.c           |    2 +-
 drivers/serial/sn_console.c            |    2 +-
 drivers/usb/serial/ftdi_sio.c          |    2 +-
 drivers/usb/serial/generic.c           |   10 ++---
 drivers/usb/serial/pl2303.c            |    2 +-
 drivers/usb/serial/ssu100.c            |    2 +-
 drivers/xen/manage.c                   |    2 +-
 include/linux/miscdevice.h             |    1 +
 include/linux/serial_core.h            |    2 +-
 include/linux/sysrq.h                  |   16 +++++----
 include/linux/uinput.h                 |    1 -
 include/linux/usb/serial.h             |    3 +-
 kernel/debug/debug_core.c              |    2 +-
 kernel/debug/kdb/kdb_main.c            |    2 +-
 kernel/power/poweroff.c                |    2 +-
 31 files changed, 75 insertions(+), 80 deletions(-)

-- 
Dmitry

