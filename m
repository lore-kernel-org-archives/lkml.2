Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0G2KQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:16:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42652 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0G2KQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:16:35 -0400
X-IronPort-AV: E=Sophos;i="4.55,279,1278302400"; 
   d="scan'208";a="107549355"
Subject: [GIT/PATCH 0/4] Do not use IRQF_TIMER for non timer interrupts
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <alpine.LFD.2.00.1007291045060.2471@localhost.localdomain>
References: <1280314445.24292.90.camel@zakaz.uk.xensource.com>
	 <1280314467-5637-1-git-send-email-ian.campbell@citrix.com>
	 <alpine.LFD.2.00.1007291045060.2471@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 29 Jul 2010 11:16:13 +0100
Message-ID: <1280398573.24292.1684.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 09:49 +0100, Thomas Gleixner wrote:
> On Wed, 28 Jul 2010, Ian Campbell wrote:
> 
> > Continue to provide IRQF_TIMER as an alias to IRQF_NO_SUSPEND since I
> > think it is worth preserving the nice self-documenting name (where it
> > is used appropriately). It also avoid needing to patch all the many
> > users who are using the flag for an actual timer interrupt.
> 
> I'm not happy about the alias. What about:
> 
> #define __IRQF_TIMER		0x00000200
> #define IRQF_NO_SUSPEND		0x00000400
> 
> #define IRQF_TIMER    (__IRQF_TIMER | IRQF_NO_SUSPEND)

Resending with this change. Plus I ran checkpatch on the whole lot (I
previously managed to run it only on the first patch) and fixed the
complaints.

Ian.

The following changes since commit fc0f5ac8fe693d1b05f5a928cc48135d1c8b7f2e:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-irq/irqf-no-suspend

Ian Campbell (4):
      irq: Add new IRQ flag IRQF_NO_SUSPEND
      ixp4xx-beeper: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupt
      powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for non-timer interrupts
      xen: do not suspend IPI IRQs.

 arch/powerpc/platforms/powermac/low_i2c.c |    5 +++--
 drivers/input/misc/ixp4xx-beeper.c        |    3 ++-
 drivers/macintosh/via-pmu.c               |    9 +++++----
 drivers/xen/events.c                      |    1 +
 include/linux/interrupt.h                 |    7 ++++++-
 kernel/irq/manage.c                       |    2 +-
 6 files changed, 18 insertions(+), 9 deletions(-)


