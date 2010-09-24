Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0IXEuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:50:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750963Ab0IXEuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:50:12 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX180cgNBSSc0+gs+esRTqmEG0ERej8B3bF/WSHytZS
	FIL+KcflIw2VFG
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 0/4] initial suspend and resume support
Date: Fri, 24 Sep 2010 05:01:22 +0000
Message-Id: <cover.1285303222.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this little patch series finally adds basic suspend and resume support.
The good thing is, that it nearly works. Well in fact it should work
fine if the only connected device is a CRT. For other devices it might
happen that suspend and resume works but the screen stays black. This
is probably caused by auxiliary devices that are connect via I2C lines
and not yet reinitialized properly.
This should be a huge improvent above the current behaviour, especially
the hardware acceleration including a visible cursor works.

As usual tests were performed on CLE266, VX800 and VX855.
These patches are also available on
	git://github.com/schandinat/linux-2.6.git viafb-s4v1

Happy testing :)


Thanks,

Florian Tobias Schandinat


Deepak Saxena (1):
  Minimal support for viafb suspend/resume

Florian Tobias Schandinat (3):
  viafb: restore display on resume
  viafb: make suspend and resume work (on all machines?)
  viafb: fix hardware acceleration for suspend & resume

 drivers/video/via/accel.c    |   43 +++++++++++++++++++++++++----------------
 drivers/video/via/accel.h    |    3 +-
 drivers/video/via/via-core.c |    4 +++
 drivers/video/via/viafbdev.c |   43 +++++++++++++++++++++++++++++++++++++++++-
 drivers/video/via/viafbdev.h |    2 +
 5 files changed, 76 insertions(+), 19 deletions(-)

