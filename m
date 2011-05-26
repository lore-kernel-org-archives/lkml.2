Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1EZDIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:08:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54230 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1EZDIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:08:00 -0400
X-Nat-Received: from [202.181.97.72]:52786 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1306379273.9389
Message-Id: <201105260307.p4Q37qeV067663@www262.sakura.ne.jp>
Subject: PTRACE: compat_sys_ptrace(PTRACE_TRACEME) lacks arch_ptrace_attach()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: hskinnemoen@atmel.com, roland@redhat.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 12:07:52 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 26052011 #5433493, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that commit 6ea6dd93 "ptrace: Call arch_ptrace_attach() when
request=PTRACE_TRACEME" added

	if (!ret)
		arch_ptrace_attach(current);

call to sys_ptrace(PTRACE_TRACEME) but commit c269f196 "x86: compat_sys_ptrace"
did not add that call to compat_sys_ptrace(PTRACE_TRACEME).

If compat_sys_ptrace(PTRACE_ATTACH) needs arch_ptrace_attach(), maybe
compat_sys_ptrace(PTRACE_TRACEME) needs arch_ptrace_attach() as well.
