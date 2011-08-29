Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1H2X1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:27:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43950 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1H2X1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:27:43 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        mtosatti@redhat.com, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Date: Mon, 29 Aug 2011 17:27:11 -0600
Message-Id: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when qemu stops a guest kernel that guest will issue a soft lockup
message when it resumes.  This set provides the ability for qemu to comminucate
to the guest that it has been stopped.  When the guest hits the watchdog on
resume it will check if it was suspended before issuing the warning.

Eric B Munson (4):
  Add flag to indicate that a vm was stopped by the host
  Add functions to check if the host has stopped the vm
  Add generic stubs for kvm stop check functions
  Add check for suspended vm in softlockup detector

 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/include/asm/pvclock.h     |    2 ++
 arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
 include/asm-generic/pvclock.h      |   14 ++++++++++++++
 kernel/watchdog.c                  |   12 ++++++++++++
 5 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/pvclock.h

-- 
1.7.4.1

