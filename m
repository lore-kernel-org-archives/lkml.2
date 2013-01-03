Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3ACHA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:00:26 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:44881 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3ACHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:00:23 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
CC: <linux-kernel@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RESEND PATCH] Convert PARISC sysctl to be generic
Date: Thu, 3 Jan 2013 12:29:47 +0530
Message-ID: <1357196388-1247-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <50D2B75A.3000208@synopsys.com>
References: <50D2B75A.3000208@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This came out ARC Port's review by Arnd where he suggested using the existing
sysctl knobs in parisc and/or ia64 for runtime controlling unaligned access
emulation.

Turns out that ARC port needs bit of both.

The common sysctl knobs are now #ifdef based on init/Kconfig options which
the corresponding arches now select in their Kconfigs.
No other arch code is touched (although code has not been compile tested).

If this patch is ACKable, I would request you to please take this patch
via your arch tree - to avoid any merge-hassles and other interdependencies
later.

P.S. I've deliberately NOT added the new items at the end of arch/*/Kconfig,
to avoid any merge conflicts going further - anyhow both the ia64/parisc
Kconfigs are not sorted either.

Thx,
-Vineet


Vineet Gupta (1):
  sysctl: Enable PARISC "unaligned-trap" to be used cross-arch

 arch/parisc/Kconfig |    1 +
 init/Kconfig        |    8 ++++++++
 kernel/sysctl.c     |    7 ++++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

-- 
1.7.4.1

