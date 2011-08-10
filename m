Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1HJUFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:05:55 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:53956 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283Ab1HJUFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:05:54 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, gregkh@suse.de, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 0/2] new cpumask for hotpluggable CPUs
Date: Wed, 10 Aug 2011 13:03:32 -0700
Message-Id: <1313006614-28702-1-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces a new cpumask which tracks CPUs that
support hotplugging.  The purpose of this patch series is to provide a
simple method for kernel code to know which CPUs can be hotplugged and
which ones cannot.  Potential users of this code might be a thermal
mitigation technique which uses hotplug to lower temperature, or a power
capping mechanism which uses hotplug to lower power consumption.

All the of usual cpumask helper functions are created for this new mask.
The second patch in this series simply sets the bit for elligible CPUs
while they are being registered.  The cpumask itself is static after
boot and should not change (like the possbile mask).

Mike Turquette (2):
  cpumask: introduce cpumask for hotpluggable CPUs
  cpu: update cpu_hotpluggable_mask in register_cpu

 drivers/base/cpu.c      |    4 +++-
 include/linux/cpumask.h |   27 ++++++++++++++++++++++-----
 kernel/cpu.c            |   18 ++++++++++++++++++
 3 files changed, 43 insertions(+), 6 deletions(-)

-- 
1.7.4.1

