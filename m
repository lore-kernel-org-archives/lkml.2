Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0EEHeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab0EEHeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:34:04 -0400
From: Avi Kivity <avi@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>, Dexuan Cui <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 0/2] x86 FPU API
Date: Wed,  5 May 2010 10:33:20 +0300
Message-Id: <1273044802-4648-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all fpu accessors are wedded to task_struct.  However kvm also uses
the fpu in a different context.  Introduce an FPU API, and replace the
current uses with the new API.

While this patchset is oriented towards deeper changes, as a first step it
simlifies xsave for kvm.

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

