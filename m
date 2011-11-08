Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1KHAeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:34:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64473 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1KHAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:33:58 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Fix and re-enable vsyscall=emulate
Date: Mon,  7 Nov 2011 16:33:39 -0800
Message-Id: <cover.1320712291.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
References: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The really nice fix (wiring up access_ok failures to be able to raise
signals) won't be ready on time for 3.2, so let's try the simpler fix
for now.

Changes from the earlier version:
 - Clean up the odd ptr==0 check.
 - Flip the default back to vsyscall=emulate

Andy Lutomirski (2):
  x86-64: Set siginfo and context on vsyscall emulation faults
  x86: Default to vsyscall=emulate

 Documentation/kernel-parameters.txt |    7 +--
 arch/x86/include/asm/thread_info.h  |    3 +-
 arch/x86/include/asm/uaccess.h      |    2 +-
 arch/x86/kernel/vsyscall_64.c       |   77 ++++++++++++++++++++++++++++++----
 arch/x86/mm/extable.c               |    2 +-
 arch/x86/mm/fault.c                 |   22 +++++++---
 6 files changed, 91 insertions(+), 22 deletions(-)

-- 
1.7.6.4

