Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0EFIq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab0EFIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:46:24 -0400
From: Avi Kivity <avi@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>, Dexuan Cui <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v3 0/2] x86 FPU API
Date: Thu,  6 May 2010 11:45:44 +0300
Message-Id: <1273135546-29690-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all fpu accessors are wedded to task_struct.  However kvm also uses
the fpu in a different context.  Introduce an FPU API, and replace the
current uses with the new API.

While this patchset is oriented towards deeper changes, as a first step it
simlifies xsave for kvm.

v3:
	use u8 instead of bool in asm to avoid bad code generation on older
        gccs.

v2:
	eliminate useless padding in use_xsave() by using a larger instruction

Avi Kivity (2):
  x86: eliminate TS_XSAVE
  x86: Introduce 'struct fpu' and related API

 arch/x86/include/asm/i387.h        |  135 +++++++++++++++++++++++++++---------
 arch/x86/include/asm/processor.h   |    6 ++-
 arch/x86/include/asm/thread_info.h |    1 -
 arch/x86/include/asm/xsave.h       |    7 +-
 arch/x86/kernel/cpu/common.c       |    5 +-
 arch/x86/kernel/i387.c             |  107 ++++++++++++++---------------
 arch/x86/kernel/process.c          |   20 +++---
 arch/x86/kernel/process_32.c       |    2 +-
 arch/x86/kernel/process_64.c       |    2 +-
 arch/x86/kernel/xsave.c            |    8 +-
 arch/x86/math-emu/fpu_aux.c        |    6 +-
 11 files changed, 181 insertions(+), 118 deletions(-)

