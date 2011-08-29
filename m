Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1H2LeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:34:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2LeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:34:03 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linaro-dev@lists.linaro.org,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH 0/4] dmaeninge/ste_dma40: bug fixes for 3.1
Date: Mon, 29 Aug 2011 13:33:31 +0200
Message-Id: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Started off fixing a memory leak due to not freed dma descriptors
in mmci. The descriptor allocated at device_prep...(), not submitted,
isn't freed at dmaeninge_terminate_all() or dmaengine_release().
While sorting this one out some other issues were found as well.
* kernel doc missing
* duplication of d40_pool_lli_free()
* free of client descriptor triggers an oops.

Per Forlin (4):
  dmaengine/ste_dma40: add missing kernel doc for pending_queue
  dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
  dmaengine/ste_dma40: fix Oops due to double free of client descriptor
  dmaengine/ste_dma40: fix memory leak due to prepared descriptors

 drivers/dma/ste_dma40.c |   42 +++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

-- 
1.7.4.1

