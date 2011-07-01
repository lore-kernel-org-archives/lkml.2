Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1GANXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:23:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61821 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab1GANXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:23:45 -0400
Date: Fri, 1 Jul 2011 09:23:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.0-rc5
Message-ID: <20110701132333.GA14495@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E0DCA5E.006A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes

which is based on git commit acd049c6e99d2ad1195666195230f6881d1c1588
Konrad Rzeszutek Wilk (1):

    xen/setup: Fix for incorrect xen_extra_mem_start.

which you had pulled in 3.0-rc4 time-frame.

This git pull fixes two rare corner cases. One is a bootup where the INT_SRC_OVR global_irq
!= source_irq for ACPI SCI causing the ACPI interpreter to abort and going in legacy IRQ mode.
Tose machines are rare and most of them support a knob to turn it off: a BIOS option called
'ACPI SCI: Enabled/Disabled'. The other is a linker issue if a user wants an UP kernel.

Konrad Rzeszutek Wilk (2):
      xen/mmu: Fix for linker errors when CONFIG_SMP is not defined.
      xen/pci: Use the INT_SRC_OVR IRQ (instead of GSI) to preset the ACPI SCI IRQ.

 arch/x86/pci/xen.c |   26 ++++++++++++++++++++++++--
 arch/x86/xen/mmu.c |    4 ++++
 2 files changed, 28 insertions(+), 2 deletions(-)
