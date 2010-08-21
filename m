Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0HUOwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:52:17 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:40536 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737Ab0HUOwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:52:14 -0400
Subject: TRACE: config warning for IRQSOFF_TRACER
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 15:52:12 +0100
Message-ID: <1282402332.1978.32.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my config with PROVE_LOCKING=n and FTRACE=y (which defaults
IRQSOFF_TRACER to y), I get the following warning from make oldconfig.

scripts/kconfig/conf --oldconfig arch/x86/Kconfig
warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE &&
TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects
TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL &&
TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING)

The problem is that TRACE_IRQFLAGS depends on PROVE_LOCKING.
Should it select PROVE_LOCKING instead? or is there a better way to fix
this?

regards

Richard




