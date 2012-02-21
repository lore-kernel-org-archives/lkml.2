Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2BUVjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:39:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35677 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab2BUVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:39:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.68.241.170 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
Date: Tue, 21 Feb 2012 13:39:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] i387: FP state interface cleanups
In-Reply-To: <4F440945.1020904@zytor.com>
Message-ID: <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com>
 <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 13:32:49 -0800
Subject: [PATCH 0/2] i387: FP state interface cleanups

This cleans up some of our FP-state mess.  The aim is to expose much
less of the internal interfaces and implementation to various users that
really don't care. 

We shouldn't export our internal 'fpu_owner_task' tracking to modules,
and we shouldn't expose all the low-level FP state save/restore code to
code that simply must never use it anyway.

This passed allmodconfig on x86-32 and -64.

              Linus

Linus Torvalds (2):
  i387: uninline the generic FP helpers that we expose to kernel
    modules
  i387: split up <asm/i387.h> into exported and internal interfaces

 arch/x86/ia32/ia32_signal.c         |    1 +
 arch/x86/include/asm/fpu-internal.h |  520 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/i387.h         |  590 +----------------------------------
 arch/x86/kernel/cpu/common.c        |    3 +-
 arch/x86/kernel/i387.c              |   83 +++++-
 arch/x86/kernel/process.c           |    1 +
 arch/x86/kernel/process_32.c        |    1 +
 arch/x86/kernel/process_64.c        |    1 +
 arch/x86/kernel/ptrace.c            |    1 +
 arch/x86/kernel/signal.c            |    1 +
 arch/x86/kernel/traps.c             |    1 +
 arch/x86/kernel/xsave.c             |    1 +
 arch/x86/kvm/vmx.c                  |    2 +-
 arch/x86/kvm/x86.c                  |    1 +
 arch/x86/power/cpu.c                |    1 +
 15 files changed, 624 insertions(+), 584 deletions(-)
 create mode 100644 arch/x86/include/asm/fpu-internal.h

-- 
1.7.9.188.g12766.dirty

