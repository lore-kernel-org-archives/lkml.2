Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2DDMHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:07:47 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:55212 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab2DDMHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:07:46 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 08:07:46 EDT
From: Mike Sinkovsky <msink@trikom.ru>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: Mike Sinkovsky <msink@permonline.ru>
Subject: [PATCH v8 0/2] Ethernet drivers for WIZnet chips
Date: Wed,  4 Apr 2012 17:57:38 +0600
Message-Id: <1333540660-30551-1-git-send-email-msink@trikom.ru>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1333524216-23488-1-git-send-email-msink@permonline.ru>
References: <1333524216-23488-1-git-send-email-msink@permonline.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Sinkovsky <msink@permonline.ru>

Based on original driver from chip manufacturer, but nearly full rewite.
Tested and used in production with Blackfin BF531 embedded processor.

Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
---
v8:
 - use plain request_irq() and request_any_context_irq() in probe(),
   and free_irq() in remove(), to avoid races when removing driver
v7:
 - new tx flow control, configurable from Kconfig
v6:
 - remove (S0_TX_FSR < skb->len) check in TX handler, it doesn't work
   anyway. Chip can transmit only one frame with MTU 1500 at a time,
   and tx buffer size is bigger.
 - move link_gpio from RES_IO resource to wiznet_platform_data
 - remove dependency (ARM || BLACKFIN) - should work on any arch
 - interrupt handler returns IRQ_NONE if status register is zero
 - use devm_request_threaded_irq for request detect_link handler
 - remove dev_info if probe failed
v5:
 - added driver for WIZnet W5100
 - disabled VLAN (NETIF_F_VLAN_CHALLENGED)
v4:
 - netif_stop_queue if tx fifo is full, netif_wake_queue in interrupt
 - use netif_info macro
v3:
 - reading macaddr from platform_data
 - ethtool: get_link, get_msglevel, set_msglevel
 - more cleanups
v2:
 - corrected handling of NET_ADDR_RANDOM flag
 - support for WIZNET_BUS_ANY mode
 - link detection using gpio
 - registers read using ethtool
 - more cleanups

