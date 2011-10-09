Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1JILLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:11:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1JILLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:11:54 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/7] Enable WPA with wlags49_h2
Date: Sun,  9 Oct 2011 12:11:30 +0100
Message-Id: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes WPA work on the Hermes II based cards. This has been
tested with a PCMCIA Speedtouch 110 (by Henk de Groot). WEP is
confirmed to still work.

ap_scan=2 must be set on wpa_supplicant: the driver manages roaming
within the SSID and does not support SIOCSIWAP. ap_scan=1 does not
work, which is also my experience with orinoco Agere cards (although
there have been reports of that working). Because of this,
NetworkManager doesn't work when set to use WPA.

Patches 2, 5 and 6 are where the main work is done. The other patches
just clean a few things up.

David Kilroy (7):
  staging: wlags49_h2: Handle sysfs_create_group return correctly
  staging: wlags49_h2: Enable WPA in the HCF
  staging: wlags49_h2: Remove useless IWE_STREAM_ADD_XXX defines
  staging: wlags49_h2: Report WPA IE in scan results with IWEVGENIE
  staging: wlags49_h2: Make key setting more reliable
  staging: wlags49_h2: Fixup IW_AUTH handling
  staging: wlags49_h2: Fixup SIOCSIWGENIE

 drivers/staging/wlags49_h2/Makefile      |    1 -
 drivers/staging/wlags49_h2/hcfcfg.h      |   19 +-
 drivers/staging/wlags49_h2/wl_internal.h |    8 +-
 drivers/staging/wlags49_h2/wl_main.c     |    6 +-
 drivers/staging/wlags49_h2/wl_sysfs.c    |   18 +-
 drivers/staging/wlags49_h2/wl_wext.c     |  917 +++++++++++++++---------------
 drivers/staging/wlags49_h25/Makefile     |    1 -
 7 files changed, 501 insertions(+), 469 deletions(-)

-- 
1.7.4.1

