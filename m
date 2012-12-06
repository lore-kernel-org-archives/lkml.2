Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab2LFKwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:52:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36537 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965008Ab2LFKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:52:12 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/3] gpio: twl4030: Correct status reporting for outputs
Date: Thu, 6 Dec 2012 11:52:04 +0100
Message-ID: <1354791127-20545-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As Grant commneted on the first version:
https://lkml.org/lkml/2012/12/5/53

Introduce bitfields to cache the directionand output status of the pins so we
can report them correctly.
To do this I did some cleanup within the driver to get rid of the global
variables and moved them under a private structure, changed the locking as well
to protect the bitfield operation.
As a last patch I added a note that the PWMA/B handling should not be in this
driver at all.

Regards,
Peter
---
Peter Ujfalusi (3):
  gpio: twl4030: Introduce private structure to store variables needed
    runtime
  gpio: twl4030: Cache the direction and output states in private data
  gpio: twl4030: TODO comment to remove the PWMA/B (LEDA/B) handling

 drivers/gpio/gpio-twl4030.c | 177 ++++++++++++++++++++++++++++----------------
 1 file changed, 115 insertions(+), 62 deletions(-)

-- 
1.8.0

