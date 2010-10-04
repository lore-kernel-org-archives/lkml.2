Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0JDS5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:57:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19543 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab0JDS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:57:06 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, jbaron@redhat.com
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH v2 0/2] jump label: Add MIPS architecture support.
Date: Mon,  4 Oct 2010 11:56:53 -0700
Message-Id: <1286218615-24011-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
X-OriginalArrivalTime: 04 Oct 2010 18:57:10.0123 (UTC) FILETIME=[F2C38BB0:01CB63F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Make arch_jump_label_text_poke_early() optional.  As pointed out
by Rabin Vincent, the MIPS NOP is already optimal and does not need to
be replaced at boot time.  It is possible that SPARC should leave
arch_jump_label_text_poke_early() unimplementd, but I leave that work
for others as I cannot test it.

v1: Add MIPS jump label support.


David Daney (2):
  jump label: Make arch_jump_label_text_poke_early() optional
  jump label: Add MIPS support.

 arch/mips/Kconfig                   |    1 +
 arch/mips/include/asm/jump_label.h  |   48 +++++++++++++++++++++++++++++++++
 arch/mips/kernel/Makefile           |    3 +-
 arch/mips/kernel/jump_label.c       |   50 +++++++++++++++++++++++++++++++++++
 arch/mips/kernel/module.c           |    5 +++
 arch/sparc/include/asm/jump_label.h |    1 +
 arch/x86/include/asm/jump_label.h   |    1 +
 include/linux/jump_label.h          |    6 ++++
 8 files changed, 114 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/jump_label.h
 create mode 100644 arch/mips/kernel/jump_label.c

Cc: David Miller <davem@davemloft.net>
-- 
1.7.2.2

