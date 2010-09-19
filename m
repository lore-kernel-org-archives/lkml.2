Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab0ISHPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:15:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57400 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750779Ab0ISHPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:15:19 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/UMPdAM43U2CjipAjMOf4jfZJqjVV0EZTv4q166O
	7AqytcjUK06TNk
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 00/12] viafb output device rework - part 2
Date: Sun, 19 Sep 2010 07:26:05 +0000
Message-Id: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this part of the patch series has finally a huge impact on the user
experience:

- A new/extended interface in proc allows enabling/disabling of output
  devices during runtime

- The device initialization time is significant shorter after reducing
  I2C timing values to a sane limit

- A regression is fixed that prevented detection of VT1636 chips and
  therefore broke the framebuffer in such configurations

But it contains also a lot of changes in the background that will
(hopefully) lead to a better future.

The complete patch series until now can also be found at
	git://github.com/schandinat/linux-2.6.git viafb-s3v1

As usual, some tests were performed on CLE266, VX800 and VX855.

Any opinions/suggestions?


Have fun,

Florian Tobias Schandinat


Florian Tobias Schandinat (12):
  viafb: add interface for output device configuration
  viafb: limit LCD code impact
  viafb: introduce per output device power management
  viafb: vt1636 cleanup
  viafb: fix i2c_transfer error handling
  viafb: enable I2C for CRT
  viafb: reduce I2C timeout and delay
  viafb: add function to change sync polarity per device
  viafb: set sync polarity for all output devices
  viafb: add a mapping of supported output devices
  viafb: rename output devices
  viafb: add documentation for proc interface

 Documentation/fb/viafb.txt   |   48 ++++++++
 drivers/video/via/Makefile   |    2 +-
 drivers/video/via/dvi.c      |   25 +----
 drivers/video/via/global.h   |    1 -
 drivers/video/via/hw.c       |  265 ++++++++++++++++++++++++++++++++++++------
 drivers/video/via/hw.h       |   30 ++++-
 drivers/video/via/lcd.c      |   41 -------
 drivers/video/via/tbl1636.c  |   71 -----------
 drivers/video/via/tbl1636.h  |   34 ------
 drivers/video/via/via-core.c |    2 +-
 drivers/video/via/via_i2c.c  |   31 ++++-
 drivers/video/via/viafbdev.c |  225 ++++++++++++++++++++++++++++++++----
 drivers/video/via/viafbdev.h |    2 +
 drivers/video/via/vt1636.c   |  121 +++++++-------------
 14 files changed, 576 insertions(+), 322 deletions(-)
 delete mode 100644 drivers/video/via/tbl1636.c
 delete mode 100644 drivers/video/via/tbl1636.h

