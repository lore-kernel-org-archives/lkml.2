Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1EVS7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 14:59:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35574 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752560Ab1EVS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 14:59:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/66/wWSWL6u+s5/95Gt2NgMNrVNr1PMD9ikD6cz1
	9jiW5SGp40kkmC
Message-ID: <4DD95D51.6010100@gmx.de>
Date: Sun, 22 May 2011 19:00:33 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Subject: [GIT PULL] viafb updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

as Paul Mundt, the fbdev maintainer, has been inactive for several weeks now, I 
ask you to pull these viafb updates for 2.6.40 from

   git://github.com/schandinat/linux-2.6.git viafb-next

They contain major cleanups, a better PLL/clock management and some notable 
changes for users like write-combining speeding userspace apps up to a factor 
around 6 (on newer hardware) and other things making viafb more likely to work. 
Also some important changes to make it work on OLPC XO 1.5 (again).
This stuff has been in linux-next for some time.


Thanks,

Florian Tobias Schandinat


Daniel Drake (1):
       viafb: Automatic OLPC XO-1.5 configuration

Florian Tobias Schandinat (26):
       viafb: move initialization code
       viafb: no need to write CRTC values twice
       viafb: kill crt_setting_information
       viafb: allow some pll calculations
       viafb: remove unused max_hres/vres
       viafb: call viafb_get_clk_value only in viafb_set_vclock
       viafb: prepare for PLL separation
       viafb: add clock source selection and PLL power management support
       viafb: add primary/secondary clock on/off switches
       viafb: split clock and PLL code to an extra file
       viafb: add VIA slapping capability
       viafb: add engine clock support
       viafb: gather common good, old VGA initialization in one place
       viafb: some small cleanup for global variables
       viafb: replace custom return values
       viafb: delete clock and PLL initialization
       viafb: fix OLPC DCON refresh rate
       viafb: fix OLPC XO 1.5 device connection
       viafb: reduce OLPC refresh a bit
       viafb: add X server compatibility mode
       Merge branch 'viafb-olpc' into viafb-next
       Merge branch 'viafb-cleanup' into viafb-next
       Merge branch 'viafb-pll' into viafb-next
       viafb: use write combining for video ram
       viafb: try to map less memory in case of failure
       viafb: remove unused CEA mode

  drivers/video/Kconfig         |   11 +
  drivers/video/via/Makefile    |    2 +-
  drivers/video/via/chip.h      |    6 -
  drivers/video/via/dvi.c       |  160 +----------
  drivers/video/via/dvi.h       |    2 +-
  drivers/video/via/global.c    |    4 -
  drivers/video/via/global.h    |    2 -
  drivers/video/via/hw.c        |  630 ++++++++++++++---------------------------
  drivers/video/via/hw.h        |   15 +-
  drivers/video/via/lcd.c       |   23 +-
  drivers/video/via/lcd.h       |    2 +-
  drivers/video/via/share.h     |   17 +-
  drivers/video/via/via-core.c  |    9 +-
  drivers/video/via/via_clock.c |  349 +++++++++++++++++++++++
  drivers/video/via/via_clock.h |   76 +++++
  drivers/video/via/viafbdev.c  |   62 +++--
  drivers/video/via/viafbdev.h  |    4 -
  drivers/video/via/viamode.c   |   46 +---
  drivers/video/via/viamode.h   |    9 -
  19 files changed, 723 insertions(+), 706 deletions(-)
  create mode 100644 drivers/video/via/via_clock.c
  create mode 100644 drivers/video/via/via_clock.h
