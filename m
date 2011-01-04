Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1ADTh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:37:28 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:22222 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1ADThZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:37:25 -0500
Subject: [PATCH 0/2] IRQ affinity reverse-mapping
From: Ben Hutchings <bhutchings@solarflare.com>
To: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>
Cc: Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 04 Jan 2011 19:37:22 +0000
Message-ID: <1294169842.3636.31.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jan 2011 19:37:25.0423 (UTC) FILETIME=[D06613F0:01CBAC46]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17872.005
X-TM-AS-Result: No--16.283000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is intended to support queue selection on multiqueue
IRQ-per-queue network devices (accelerated RFS and XPS-MQ) and
potentially queue selection for other classes of multiqueue device.

The first patch implements IRQ affinity notifiers, based on the outline
that Thomas wrote in response to my earlier patch series for accelerated RFS.

The second patch is a generalisation of the CPU affinity reverse-
mapping, plus functions to maintain such a mapping based on the new IRQ
affinity notifiers.

I would like to be able to use this functionality in networking for
2.6.38.  Thomas, if you are happy with this, could these changes go
through net-next-2.6?  Alternately, if Linus pulls from linux-2.6-tip
and David pulls from Linus during the merge window, I can (re-)submit
the dependent changes after that.

Ben.

Ben Hutchings (2):
  genirq: Add IRQ affinity notifiers
  lib: cpu_rmap: CPU affinity reverse-mapping

 include/linux/cpu_rmap.h  |   73 +++++++++++++
 include/linux/interrupt.h |   41 +++++++
 include/linux/irqdesc.h   |    3 +
 kernel/irq/manage.c       |   81 ++++++++++++++
 lib/Kconfig               |    4 +
 lib/Makefile              |    2 +
 lib/cpu_rmap.c            |  262 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 466 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/cpu_rmap.h
 create mode 100644 lib/cpu_rmap.c

-- 
1.7.3.4


-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

