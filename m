Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2IRDQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2IRDQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:16:12 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v10 0/2] kvm: level irqfd support
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 21:16:11 -0600
Message-ID: <20120918031156.12021.27838.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated with suggestions from Michael and Avi, the OADN option is
now a "resample" option.  Re-working locking went surprisingly
well, lockdep clean, and now allows us to use a single irq source
ID for all resample irqfds.  I hope we're close.  Thanks,

Alex

---

Alex Williamson (2):
      kvm: Add resampling irqfds for level triggered interrupts
      kvm: Provide pre-locked setup to irq ack notifier


 Documentation/virtual/kvm/api.txt |   13 +++
 arch/x86/kvm/x86.c                |    4 +
 include/linux/kvm.h               |   12 ++-
 include/linux/kvm_host.h          |    8 +-
 virt/kvm/eventfd.c                |  175 ++++++++++++++++++++++++++++++++++++-
 virt/kvm/irq_comm.c               |   24 +++++
 virt/kvm/kvm_main.c               |    2 
 7 files changed, 230 insertions(+), 8 deletions(-)
