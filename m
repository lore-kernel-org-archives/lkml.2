Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423428Ab2LFMri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 07:47:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:51729 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423413Ab2LFMrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:47:37 -0500
From: Benedikt Spranger <b.spranger@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 0/2] uio: some fixes
Date: Thu,  6 Dec 2012 13:44:55 +0100
Message-Id: <1354797897-23423-1-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using uio_pdrv_genirq can cause a system hangup due to accessing mmaped memory,
since the pm_runtime_put_sync() call in uio_release can disable clocks.
Also unloading a module wich creates/removes UIO devices can cause a system
crash. Track mappings and get a module reference to avoid this.

Benedikt Spranger (2):
  uio: be aware of open(), mmap(), close()
  uio: avoid module unloding of in module created UIO devices

 drivers/uio/uio.c             |   67 ++++++++++++++++++++++++++++++++---------
 drivers/uio/uio_pdrv_genirq.c |    4 +--
 include/linux/uio_driver.h    |    5 +--
 3 files changed, 57 insertions(+), 19 deletions(-)

-- 
1.7.10.4

