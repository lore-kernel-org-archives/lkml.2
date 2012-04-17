Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2DQSed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:34:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47935 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2DQSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:34:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        ming.m.lin@intel.com, hpa@zytor.com, rjw@sisk.pl, x86@kernel.org
Subject: [PATCH] gts and bfs fixes (v3).
Date: Tue, 17 Apr 2012 14:29:17 -0400
Message-Id: <1334687359-9970-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F8DB7B0.0077,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v2 [https://lkml.org/lkml/2012/4/9/474]
 - ditched the assembler version and used a C wrapper

With git commit a2ef5c4fd44ce3922435139393b89f2cce47f576
"ACPI: Move module parameter gts and bfs to sleep.c" the
sampling of gts/bfs module parameters flag by acpi_enter_sleep_state
has been moved. It has been moved out of the inner ACPI code and
out in the more x86 specific. This means that any caller of
the exported acpi_enter_sleep_state function needs to provide
two parameters now: sleep state and the bit flag whether to us _GTS|_BFS.

All of the callers of acpi_enter_sleep_state did that, with
the exception of the assembler version and as well any
third-party callers of acpi_enter_sleep_state.

These two patches expose 'wake_sleep_flags' as the product
of the gts/bfs module parameter invocation. And also use said
flag in the assembler 'do_suspend_lowlevel()' function.

Konrad Rzeszutek Wilk (2):
      ACPI: Convert wake_sleep_flags to a value instead of function (v4)
      x86/acpi: Call acpi_enter_sleep_state via an asmlinkage C function from assembler.

 arch/x86/kernel/acpi/sleep.c     |    4 +++
 arch/x86/kernel/acpi/sleep.h     |    4 +++
 arch/x86/kernel/acpi/wakeup_32.S |    3 +-
 arch/x86/kernel/acpi/wakeup_64.S |    3 +-
 drivers/acpi/sleep.c             |   52 ++++++++++++++++++++-----------------
 5 files changed, 38 insertions(+), 28 deletions(-)
