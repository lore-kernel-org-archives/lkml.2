Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1DHPCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:02:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab1DHPCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:02:20 -0400
From: Michal Marek <mmarek@suse.cz>
To: mjg@redhat.com
Cc: gregkh@suse.de, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Fix up samsung-laptop.c duplication
Date: Fri,  8 Apr 2011 17:02:02 +0200
Message-Id: <1302274926-25985-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The samsung-laptop.c driver got merged into drivers/platform/x86/, but a
copy also stayed in drivers/staging and further fixes got applied there.
A parallel build decides randomly which version to link into
samsung-laptop.ko, so this cannot work even if it was intentional. This
series applies the missing patches to drivers/platform/x86/ and deletes
the old version.

Michal

Alberto Mardegan (1):
  samsung-laptop: Samsung R410P backlight driver

Greg Kroah-Hartman (1):
  samsung-laptop: add support for N230 model

Michal Marek (2):
  samsung-laptop: set backlight type
  staging: samsung-laptop has moved to platform/x86

 drivers/platform/x86/samsung-laptop.c           |   17 +-
 drivers/staging/Makefile                        |    1 -
 drivers/staging/samsung-laptop/Kconfig          |   10 -
 drivers/staging/samsung-laptop/Makefile         |    1 -
 drivers/staging/samsung-laptop/TODO             |    5 -
 drivers/staging/samsung-laptop/samsung-laptop.c |  843 -----------------------
 6 files changed, 14 insertions(+), 863 deletions(-)
 delete mode 100644 drivers/staging/samsung-laptop/Kconfig
 delete mode 100644 drivers/staging/samsung-laptop/Makefile
 delete mode 100644 drivers/staging/samsung-laptop/TODO
 delete mode 100644 drivers/staging/samsung-laptop/samsung-laptop.c

-- 
1.7.4.1

