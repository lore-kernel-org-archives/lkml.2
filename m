Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0JPA5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:57:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JPA5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:57:23 -0400
Date: Fri, 15 Oct 2010 20:57:19 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>, tglx@redhat.com,
        linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca
Subject: [PATCH 0/3] m32r: cleanup irq handling and stop calling __do_IRQ
Message-ID: <20101016005719.GM8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following patches clean up m32r's irq handling to stop accessing
the irq_desc array without helpers, clean up redundant functions, and
stop calling __do_IRQ.

They are necessary, since soon __do_IRQ will be removed from the generic
IRQ handling code, in favour of the new more flexible flow handler
approach.

I've build tested it in a few configurations, but not extensively, and
it hasn't been run time tested, obviously. (Obviously the build needs
fixes which are in another patchset.)

 arch/m32r/Kconfig                    |    3 +
 arch/m32r/kernel/irq.c               |   10 +-
 arch/m32r/platforms/m32104ut/setup.c |   47 ++-------
 arch/m32r/platforms/m32700ut/setup.c |  190 ++++++++--------------------------
 arch/m32r/platforms/mappi/setup.c    |   72 +++----------
 arch/m32r/platforms/mappi2/setup.c   |   83 ++++-----------
 arch/m32r/platforms/mappi3/setup.c   |   83 ++++-----------
 arch/m32r/platforms/oaks32r/setup.c  |   59 +++--------
 arch/m32r/platforms/opsput/setup.c   |  192 ++++++++--------------------------
 arch/m32r/platforms/usrv/setup.c     |  102 ++++--------------
 10 files changed, 204 insertions(+), 637 deletions(-)

regards, Kyle McMartin
