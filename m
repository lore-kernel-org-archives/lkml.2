Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1HGP2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:28:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53325 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751917Ab1HGP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:28:31 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18YD513YEMYA4V+d+hG58JY5N7Kb/htwamezzjyAl
	OM7i8NRqh5pDAf
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 0/6] viafb modesetting update 2
Date: Sun,  7 Aug 2011 15:46:54 +0000
Message-Id: <cover.1312730859.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the second patch series. It's a little less stable than the 
previous one but it contains some great internal improvements.
We do no longer rely on the modetable structure across all sections 
and we use the values in var directly for CRT and DVI when possible. 
Basically this enables us to allow arbitary modes passed in var. 
That's not implemented yet and probably will never be the default as 
we want to do some sanity checking in check_var for the devices 
connected but would allow overriding buggy information.
Anyway with these patches it will be very simple to avoid the buggy 
modetable we use at the moment.


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (6):
  viafb: add new funcions to select a single mode
  viafb: eliminate viafb_get_pixclock
  viafb: use information in var for modesetting
  viafb: seperate hardware initialization
  viafb: eliminate modetable dependancy of LCD modesetting
  viafb: get rid of the remaining modetable structure assumptions

 drivers/video/via/dvi.c      |   30 ++----
 drivers/video/via/dvi.h      |    3 +-
 drivers/video/via/global.c   |    2 +
 drivers/video/via/global.h   |    2 +
 drivers/video/via/hw.c       |  229 ++++++++++++++++-------------------------
 drivers/video/via/hw.h       |   12 +--
 drivers/video/via/lcd.c      |   12 +--
 drivers/video/via/lcd.h      |    5 +-
 drivers/video/via/share.h    |    4 -
 drivers/video/via/viafbdev.c |   38 +++----
 drivers/video/via/viamode.c  |   58 ++++++++---
 drivers/video/via/viamode.h  |    4 +-
 12 files changed, 177 insertions(+), 222 deletions(-)

