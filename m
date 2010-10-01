Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0JAV03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:26:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34427 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab0JAV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:26:28 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 0/2] Fix IRQ round-robing w/o irqbalance on pseries
Date: Fri,  1 Oct 2010 14:26:16 -0700
Message-Id: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
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

