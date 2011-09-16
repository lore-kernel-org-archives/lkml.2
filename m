Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1IPNtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:49:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25558 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1IPNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:48:59 -0400
Date: Fri, 16 Sep 2011 09:48:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [GIT PULL]  (xen) stable/bug.fixes for 3.1-rc6
Message-ID: <20110916134846.GA27234@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E7353C9.0087,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following branch:

git pull git://oss.oracle.com/git/kwilk/xen.git stable/bug.fixes

which has fixes in:
  1). The E820 setup code (which we are planning to cleanup in 3.2/3.3 time
       -frame as it is getting bigger and nastier).
  2). Taking a spinlock while later calling the generic IRQ code which
      uses a mutex - causing the "BUG: you took spinlock while sleeping."
      Fortunately the fix is quite simple - s/spin/mutex/.
  3). The Linux guest when it runs under HVM tries to enable as many PV
      things as it can. One of them is the spinlocks - but sadly we are
      doing it too late and end up with baremetal ticket spinlocks and
      PV byte locks running at the same time. Hilarity ensues with the guest
      locking up.. we will revisit this in 3.3 time-frame.
  4). Lastly, we fix up the check for overflow and also add a WARN
      just in case it happens.

They aren't as spectacular as the previous git pull I sent that
had a bug since 2.6.27.. but nonetheless please pull!

David Vrabel (1):
      xen/e820: if there is no dom0_mem=, don't tweak extra_pages.

Jan Beulich (1):
      xen/i386: follow-up to "replace order-based range checking of M2P table by linear one"

Konrad Rzeszutek Wilk (1):
      xen/irq: Alter the locking to use a mutex instead of a spinlock.

Stefano Stabellini (1):
      xen: disable PV spinlocks on HVM

 arch/x86/xen/mmu.c   |    6 ++----
 arch/x86/xen/setup.c |   10 ++++++----
 arch/x86/xen/smp.c   |    1 -
 drivers/xen/events.c |   40 ++++++++++++++++++++--------------------
 4 files changed, 28 insertions(+), 29 deletions(-)
