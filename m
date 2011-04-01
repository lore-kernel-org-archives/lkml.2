Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab1DAQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:47:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34616 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DAQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:47:25 -0400
Date: Fri, 1 Apr 2011 17:47:13 +0100
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: RFC: ptrace: Enabling PTRACE_{GET,SET}REGSET calls without
 CONFIG_HAVE_ARCH_TRACEHOOK
Message-ID: <20110401164713.GA16870@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I notice in kernel/ptrace.c that the generic regset ptrace calls
PTRACE_GETREGSET and PTRACE_SETREGSET are predicated on
CONFIG_HAVE_ARCH_TRACEHOOK.

However, if I'm reading the code correctly then all these calls
really depend on is regsets implemented in the target arch.

Since I'm separately proposing a regsets implementation for ARM,
it would be nice to enable these ptrace calls; but I don't think
we're ready to enable CONFIG_HAVE_ARCH_TRACEHOOK there for now.

Does anyone know whether it would be safe/straightforward to
change the #ifdef in kernel/ptrace.c to something else,
such as CORE_DUMP_USE_REGSET?  I think all arches which implement
regsets define this, though I haven't researched this thoroughly.

Any views welcome.

Cheers
---Dave
