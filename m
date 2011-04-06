Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1DFLLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:11:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1DFLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:11 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 0/7] gpio: extend basic_mmio_gpio for different controllers
Date: Wed,  6 Apr 2011 12:10:56 +0100
Message-Id: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series extends the basic_mmio_gpio driver to support
controllers with different register sets and number of GPIOs.  There are
also changes to configure more at probe time rather than runtime
evaluation.

I've tested this on an out-of-tree platform with a Synopsys DesignWare
GPIO controller.

Jamie Iles (7):
  basic_mmio_gpio: remove runtime width/endianness evaluation
  basic_mmio_gpio: convert to platform_{get,set}_drvdata()
  basic_mmio_gpio: allow overriding number of gpio
  basic_mmio_gpio: request register regions
  basic_mmio_gpio: detect output method at probe time
  basic_mmio_gpio: support different input/output registers
  basic_mmio_gpio: support direction registers

 drivers/gpio/basic_mmio_gpio.c  |  386 ++++++++++++++++++++++++++++++--------
 include/linux/basic_mmio_gpio.h |    1 +
 2 files changed, 305 insertions(+), 82 deletions(-)

-- 
1.7.4

