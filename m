Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0EQJKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:10:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:40345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab0EQJKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="518507164"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v2 0/3] Convert KVM to use FPU API
Date: Mon, 17 May 2010 17:08:25 +0800
Message-Id: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change from v1:
Use unlazy_fpu() to handle host FPU, avoiding save/restore of host FPU states.

Sheng Yang (3):
  x86: Export FPU API for KVM use
  KVM: x86: Use unlazy_fpu() for host FPU
  KVM: x86: Use FPU API

 arch/x86/include/asm/i387.h     |    2 +
 arch/x86/include/asm/kvm_host.h |   18 +---------
 arch/x86/include/asm/xsave.h    |    3 ++
 arch/x86/kernel/i387.c          |    3 +-
 arch/x86/kernel/process.c       |    1 +
 arch/x86/kvm/x86.c              |   70 ++++++++++-----------------------------
 6 files changed, 27 insertions(+), 70 deletions(-)

