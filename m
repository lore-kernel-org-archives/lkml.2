Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0G1KyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:54:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27518 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0G1KyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:54:09 -0400
X-IronPort-AV: E=Sophos;i="4.55,273,1278302400"; 
   d="scan'208";a="107382875"
Subject: [GIT/PATCH 0/4] Do not use IRQF_TIMER for non timer interrupts
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <xen-devel@lists.xensource.com>, <linux-input@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 28 Jul 2010 11:54:05 +0100
Message-ID: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

A small number of users of IRQF_TIMER are using it for the implied no
suspend behaviour on interrupts which are not timer interrupts.

Therefore the following series renames the IRQF_TIMER flag to
IRQF_NO_SUSPEND and updates the users which are not timer interrupts to
use the new name. IRQF_TIMER is retained as an alias for
IRQF_NO_SUSPEND.

The final patch in the series adds a new user the flag which disables
suspend of Xen IPI IRQs.

Ian.

The following changes since commit fc0f5ac8fe693d1b05f5a928cc48135d1c8b7f2e:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-irq/irqf-no-suspend

Ian Campbell (4):
      irq: rename IRQF_TIMER to IRQF_NO_SUSPEND
      ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt
      powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupts
      xen: do not suspend IPI IRQs.

 arch/powerpc/platforms/powermac/low_i2c.c |    4 ++--
 drivers/input/misc/ixp4xx-beeper.c        |    2 +-
 drivers/macintosh/via-pmu.c               |    4 ++--
 drivers/xen/events.c                      |    1 +
 include/linux/interrupt.h                 |    8 ++++++--
 kernel/irq/manage.c                       |    2 +-
 6 files changed, 13 insertions(+), 8 deletions(-)


