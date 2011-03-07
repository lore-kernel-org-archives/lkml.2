Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1CGLlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:41:12 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51871 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1CGLlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:41:10 -0500
Date: Mon, 7 Mar 2011 17:11:04 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, anton@samba.org, benh@kernel.crashing.org
Subject: [PATCH 0/7] 2.6.32.stable kexec/kdump fixes backport series
Message-ID: <20110307114104.GB8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of kexec/kdump fixes have gone into the current upstream kernel
that need to be part of the 2.6.32-stable, Herein are the patches.

Anton Blanchard (2):
  powerpc/kdump: CPUs assume the context of the oopsing CPU
  powerpc/kdump: Use chip->shutdown to disable IRQs

Matt Evans (1):
  powerpc/kexec: Fix orphaned offline CPUs across kexec

Maxim Uvarov (1):
  powerpc/crashdump: Do not fail on NULL pointer dereferencing

Michael Neuling (2):
  powerpc/pseries: Add hcall to read 4 ptes at a time in real mode
  powerpc/kexec: Speedup kexec hash PTE tear down

Milton Miller (1):
  powerpc: Use more accurate limit for first segment memory	allocations


 arch/powerpc/include/asm/hvcall.h               |    1 +
 arch/powerpc/kernel/crash.c                     |   10 +++++-
 arch/powerpc/kernel/machine_kexec_64.c          |   25 +++++++++++++++
 arch/powerpc/kernel/setup_64.c                  |   17 ++++++++--
 arch/powerpc/platforms/pseries/hvCall.S         |   38 +++++++++++++++++++++++
 arch/powerpc/platforms/pseries/lpar.c           |   33 ++++++++++++--------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   18 +++++++++++
 7 files changed, 124 insertions(+), 18 deletions(-)


	Kamalesh
