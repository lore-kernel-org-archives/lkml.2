Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab2GCTVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab2GCTVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:21:15 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 0/2] kvm: level irqfd and new eoifd
To: avi@redhat.com, mst@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 03 Jul 2012 13:21:13 -0600
Message-ID: <20120703191106.6735.78272.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the latest iteration of adding an interface to assert and
de-assert level interrupts from external drivers like vfio.  These
apply on top of the previous argument cleanup, documentation, and
sanitization patches for irqfd.  It would be great to get this queued
in next for linux 3.6.

I believe I've addressed all the previous comments, including fixing
the locking problems in eoifd.  I've run this with lockdep adding
and removing level irqfd/eoifd pairs without any problems.  Please
let me know if there are any further comments.  Thanks,

Alex

---

Alex Williamson (2):
      kvm: KVM_EOIFD, an eventfd for EOIs
      kvm: Extend irqfd to support level interrupts


 Documentation/virtual/kvm/api.txt |   27 +++
 arch/x86/kvm/x86.c                |    2 
 include/linux/kvm.h               |   17 ++
 include/linux/kvm_host.h          |   13 ++
 virt/kvm/eventfd.c                |  307 +++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c               |   11 +
 6 files changed, 373 insertions(+), 4 deletions(-)
