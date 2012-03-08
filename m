Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2CHRzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:55:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38289 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751769Ab2CHRzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:55:12 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+CzlNj9SKCesIT1yNnRQhe+uZZ99cJhHgF1QiWxt
	K//Ieaga+f/JFd
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 0/2] viafb modetable conversion
Date: Thu,  8 Mar 2012 18:15:27 +0000
Message-Id: <cover.1331229163.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

finally the modetable conversion is here. The first patch does the 
conversion to get rid of some strange things and lot of defines.
The conversion was done by a program and causes a lot of warnings by 
generating lines longer than 80 characters which I do not consider 
worth fixing. A side effect of this conversion seems to be that CRTs 
are happier with the resulting modes/clocks as the conversion program 
used floating point and therefore the resulting pixclocks are closer to 
what they should be.
The second patch is just sort of performance optimization by avoiding 
two unnecessary modetable walks.


Best regards,

Florian Tobias Schandinat


Florian Tobias Schandinat (2):
  viafb: modetable conversion
  viafb: avoid refresh and mode lookup in set_par

 drivers/video/via/dvi.c      |    2 +-
 drivers/video/via/hw.c       |   41 +--
 drivers/video/via/hw.h       |    4 +-
 drivers/video/via/lcd.c      |   53 +---
 drivers/video/via/share.h    |  331 --------------------
 drivers/video/via/viafbdev.c |   32 +-
 drivers/video/via/viamode.c  |  713 ++++++------------------------------------
 drivers/video/via/viamode.h  |   11 +-
 8 files changed, 134 insertions(+), 1053 deletions(-)

-- 
1.7.9

