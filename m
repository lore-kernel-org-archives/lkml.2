Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2JNRTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 13:19:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54323 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2JNRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 13:19:37 -0400
From: Dmitry Fleytman <dmitry@daynix.com>
To: linux-kernel@vger.kernel.org
Cc: e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>,
        Dmitry Fleytman <dmitry@daynix.com>
Subject: [PATCH] e1000 driver RX race condition fixed
Date: Sun, 14 Oct 2012 19:19:10 +0200
Message-Id: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition in e1000 driver.
It enables HW receive before RX rings initalization.
In case of specific timing this may lead to host memory corruption
due to DMA write to arbitrary memory location.
Following patch fixes this issue by reordering initialization steps.

Other Intel network drivers does not seem to have this issue.

Dmitry Fleytman (1):
  RX initialization sequence fixed - enable RX after corresponding ring
    initialization only

 drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
 drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.7.9.5

