Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab0HFBxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:53:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934613Ab0HFBw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:52:57 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/PBNh4gizPgDTEDwyEVutdhOKPkPgBnv7Tw2DXwj
	yPGh6N4eoXR5H6
Message-ID: <4C5B6AF5.2060605@gmx.de>
Date: Fri, 06 Aug 2010 03:52:53 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] viafb updates
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull viafb updates for 2.6.36 from:

   git://github.com/schandinat/linux-2.6.git for-linus

There are some minor bugfixes, cleanups and updates as well as two significant 
changes. Two undocumented ioctls which duplicate the framebuffer interface and 
prevent a clean implementation are removed. The PLL value format change drops 
some bits which looks sane as unichrome X driver does not set those bits as well.


Thanks,

Florian Tobias Schandinat


Andrew Morton (1):
       drivers/video/via/via-gpio.c: fix warning

Ben Hutchings (1):
       viafb: Depends on X86

Florian Tobias Schandinat (11):
       MAINTAINERS: update viafb entry
       viafb: remove duplicated scaling code
       viafb: improve lcd code readability
       viafb: add lcd scaling support for some IGPs
       viafb: fix PCI table
       viafb: simplify lcd size "detection"
       viafb: PLL value cleanup
       viafb: update fix before calculating depth
       viafb: remove ioctls which break the framebuffer interface
       viafb: probe cleanups
       viafb: fix accel_flags check_var bug

Henrik Kretzschmar (1):
       fbdev: section cleanup in viafb driver

  MAINTAINERS                  |    5 +-
  drivers/video/Kconfig        |    2 +-
  drivers/video/via/chip.h     |    1 -
  drivers/video/via/hw.c       |  587 +++++++++++++++++++++++++++++-------------
  drivers/video/via/hw.h       |   14 +-
  drivers/video/via/ioctl.h    |    3 -
  drivers/video/via/lcd.c      |  117 +--------
  drivers/video/via/lcd.h      |    5 -
  drivers/video/via/share.h    |  309 ----------------------
  drivers/video/via/via-core.c |   22 +-
  drivers/video/via/via-gpio.c |    2 +-
  drivers/video/via/viafbdev.c |  284 +--------------------
  12 files changed, 449 insertions(+), 902 deletions(-)
