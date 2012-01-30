Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2A3Rby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:31:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41550 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2A3Rbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:31:53 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 0/2] generic irq chip and pl061 domain support
Date: Mon, 30 Jan 2012 11:31:37 -0600
Message-Id: <1327944699-29882-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds irq domain support for generic irq chip and updates
pl061 gpio to use it. This is has been significant re-worked from the
previous version based on Grant Likely's irq domain work and to make
the domain support optional as some arches don't use domains. A new 
function irq_setup_generic_chip_domain is added to setup a generic irq
chip with a domain.

Shawn, can you test on i.MX again. I think your case with multiple generic
irq chips for 1 device node should work, but I can't test that.

This is based on Grant Likely's irq domain work and is available here:

git://sources.calxeda.com/kernel/linux.git pl061-domain-v3

Rob

Rob Herring (2):
  irq: add irq_domain support to generic-chip
  gpio: pl061: enable interrupts with DT style binding

 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 +++
 drivers/gpio/gpio-pl061.c                          |   39 ++++---
 include/linux/irq.h                                |   10 ++
 kernel/irq/generic-chip.c                          |  134 +++++++++++++++++---
 4 files changed, 166 insertions(+), 32 deletions(-)

-- 
1.7.5.4

