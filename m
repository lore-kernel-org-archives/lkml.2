Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2KQIyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:54:37 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64160 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KQIyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:54:36 -0500
X-Nat-Received: from [202.181.97.72]:63872 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353142456.12776
To: sfr@canb.auug.org.au
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [3.7-rc6/perf,x86] Build failure at p6_pmu declaration.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201211171754.JCB26528.JLOFMFQOOFtVHS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 17 Nov 2012 17:54:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17112012 #8399086, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit caaa8be3 "perf, x86: Fix __initconst vs const" causes

  arch/x86/kernel/cpu/perf_event_p6.c:200: error: p6_pmu causes a section type conflict
  make[3]: *** [arch/x86/kernel/cpu/perf_event_p6.o] Error 1

error. Patching

  -static __initconst const struct x86_pmu p6_pmu = {
  +static __initconst struct x86_pmu p6_pmu = {

solved the error. But is this rather a compiler bug? I'm using gcc 3.3.5.
