Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0LMXAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:00:08 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50019 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0LMXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:00:06 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 0/4] KVM & genirq: Enable adaptive IRQ sharing for passed-through devices
Date: Mon, 13 Dec 2010 23:59:42 +0100
Message-Id: <cover.1292281184.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V01U2FsdGVkX18iMzfX0B4mNw0A14c9jiShRQhsoSzMMODq3VZ8
	cfq0XBnCekh5y/l75WfXRt2hdkz1pJnIbfrbIzN2D240f1833D
	BIMEBH1Gc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This addresses the review comments of the previous round:
 - renamed irq_data::status to drv_status
 - moved drv_status around to unbreak GENERIC_HARDIRQS_NO_DEPRECATED
 - fixed signature of get_irq_status (irq is now unsigned int)
 - converted register_lock into a global one
 - fixed critical white space breakage (that I just left in to check if
   anyone is actually reading the code, of course...)

Note: The KVM patch still depends on
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/64515

Thanks for all comments!

Final but critical question: Who will pick up which bits?

Jan Kiszka (4):
  genirq: Introduce driver-readable IRQ status word
  genirq: Inform handler about line sharing state
  genirq: Add support for IRQF_COND_ONESHOT
  KVM: Allow host IRQ sharing for passed-through PCI 2.3 devices

 Documentation/kvm/api.txt |   27 ++++
 arch/x86/kvm/x86.c        |    1 +
 include/linux/interrupt.h |   15 ++
 include/linux/irq.h       |    2 +
 include/linux/kvm.h       |    6 +
 include/linux/kvm_host.h  |   10 ++-
 kernel/irq/manage.c       |   77 ++++++++++-
 virt/kvm/assigned-dev.c   |  336 ++++++++++++++++++++++++++++++++++++++++-----
 8 files changed, 436 insertions(+), 38 deletions(-)

