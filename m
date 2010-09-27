Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab0I0XSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:18:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55713 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394Ab0I0XSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:18:08 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Fix IRQ round-robing w/o irqbalance on pseries
Date: Mon, 27 Sep 2010 16:17:41 -0700
Message-Id: <1285629463-27699-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have received reports on power systems not running irqbalance where
all interrupts are being routed to CPU0 rather than being interleaved by
default across the system. Current firmware only allows either sending
interrupts to all CPUs or sending them to one CPU. The following two
patches address this issue by fixing the mask used in generic code and
by fixing the check for the "all" setting in the pseries code.

Nishanth Aravamudan (2):
  IRQ: use cpu_possible_mask rather than online_mask in setup_affinity
  pseries/xics: use cpu_possible_mask rather than cpu_all_mask

 arch/powerpc/platforms/pseries/xics.c |    2 +-
 kernel/irq/manage.c                   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org

