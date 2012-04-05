Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2DEFe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 01:34:29 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:50973 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2DEFe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:34:28 -0400
From: Mike Sinkovsky <msink@permonline.ru>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: Mike Sinkovsky <msink@permonline.ru>
Subject: [PATCH v9 0/2] Ethernet drivers for WIZnet chips
Date: Thu,  5 Apr 2012 11:33:52 +0600
Message-Id: <1333604034-17656-1-git-send-email-msink@permonline.ru>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1333541339-30776-1-git-send-email-msink@permonline.ru>
References: <1333541339-30776-1-git-send-email-msink@permonline.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on original driver from chip manufacturer, but nearly full rewite.
Tested and used in production with Blackfin BF531 embedded processor.

Signed-off-by: Mike Sinkovsky <msink@permonline.ru>
---
v9:
 - fixed suspend()/restore() parameters
 - restored references to wiznet/ subdirectory in 
   drivers/net/ethernet/{Kconfig,Makefile}, somewhat lost when
   rebasing to net-next tree
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

