Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2H2Xbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:31:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2H2Xbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:31:31 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/8] KVM: minor cleanups and optimizations
Date: Thu, 30 Aug 2012 01:30:12 +0200
Message-Id: <1346283020-22385-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo

this patch series implements a few micro optimizations for the x86 KVM
code base. The two major changes are constification of variables and an
optimization for the SSE emulation. The former gives the compiler more
opportunities for optimizations and ensures the r/o data is not put in
a cache line together with data that gets written to. The latter should
speed up the emulation of SSE register moves as the aligned variant of
MOVDQ has lower latencies and higher throughput than the unaligned one.

Regards,

Mathias Krause (8):
  KVM: x86: minor size optimization
  KVM: x86 emulator: use aligned variants of SSE register ops
  KVM: x86: mark opcode tables const
  KVM: x86: constify emulate_ops
  KVM: x86: constify read_write_emulator_ops
  KVM: x86: more constification
  KVM: VMX: constify lookup tables
  KVM: SVM: constify lookup tables

 arch/x86/include/asm/kvm_emulate.h |    2 +-
 arch/x86/kvm/cpuid.c               |   12 ++--
 arch/x86/kvm/emulate.c             |  126 ++++++++++++++++++------------------
 arch/x86/kvm/lapic.c               |    2 +-
 arch/x86/kvm/svm.c                 |    8 +--
 arch/x86/kvm/vmx.c                 |   14 ++--
 arch/x86/kvm/x86.c                 |   12 ++--
 7 files changed, 88 insertions(+), 88 deletions(-)

-- 
1.7.10.4

