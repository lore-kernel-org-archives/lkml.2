Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2DPSqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:46:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46185 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2DPSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:46:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: xen-devel@lists.xensource.com, suresh.b.siddha@intel.com, hpa@zytor.com,
        hpa@zytor.co, tglx@linutronix.de
Subject: [GIT PULL] (xen) for stable/for-ingo-v3.5.v3 for v3.5
Date: Mon, 16 Apr 2012 14:40:13 -0400
Message-Id: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4F8C68E8.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,

Please git pull the following branch for v3.5:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-ingo-v3.5.v3

It has the proper fix for the IO-APIC having 0xfffff... contents when booting under Xen.

Compared to the patch you have already in the tree (136d249ef7dbf0fefa292082cc40be1ea864cbd6
 x86/ioapic: Add io_apic_ops driver layer to allow interception) it does three things:

 1) Exposes the io_apic baremetal functions and uses the x86_io_apic_ops function table
    instead of keeping it in the io_apic. This makes the code fit within the rest of
    x86_ops functions.

 2) Use the x86_io_apic_ops to re-direct the (*read) to the Xen emulated one.

 3) Removes the work-around.

Please note, that the existing interface (136d249) can be used to do 2) as well. But the
1) makes the code more uniform by putting the function table redirection in the same
location.

Thank you!

Konrad Rzeszutek Wilk (3):
      x86/apic: Replace io_apic_ops with x86_io_apic_ops.
      xen/x86: Implement x86_apic_ops
      Revert "xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'"

 arch/x86/include/asm/io_apic.h  |   35 +++++++++++++++++++----------
 arch/x86/include/asm/x86_init.h |    9 ++++++-
 arch/x86/kernel/apic/io_apic.c  |   46 +++-----------------------------------
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/x86_init.c      |    8 ++++++
 arch/x86/xen/Makefile           |    2 +-
 arch/x86/xen/apic.c             |   17 ++++++++++++++
 arch/x86/xen/enlighten.c        |    2 +
 arch/x86/xen/mmu.c              |    4 +--
 arch/x86/xen/xen-ops.h          |    4 +++
 10 files changed, 69 insertions(+), 60 deletions(-)
