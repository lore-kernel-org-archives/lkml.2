Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1KZUTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:19:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1KZUTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:19:18 -0500
From: NeilBrown <neilb@suse.de>
To: Felipe Balbi <balbi@ti.com>
Date: Sun, 27 Nov 2011 07:17:41 +1100
Subject: [PATCH 0/4] fixes for twl4030-irq in mainline
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20111126201334.16080.85045.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  The recent tidying up of twl4030-irq seems to have left it broken.
At least it doesn't work for me on my gta04 (www.gta04.org).  The
first interrupt from the device freezes the whole system (by being
constantly delivered)

The following 4 patches make it work for me and addresses some other
less critical issues like a typo in a comment :-)

Thanks,
NeilBrown


---

NeilBrown (4):
      twl4030-irq: fix typo
      twl4030-irq: set tertiary interrupts to be nested/threaded.
      twl4030-irq: use request_threaded_irq in place of irq_set_chained_handler.
      twl4030-irq: Base interrupt must be one-shot


 drivers/mfd/twl4030-irq.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

-- 
Signature

