Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab1EOOFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:05:20 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:48877 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755434Ab1EOOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:05:17 -0400
Date: Sun, 15 May 2011 16:02:32 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: getter PTRACE_GETSIGINFO should not modify anything  [Re: [PATCH
 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110515140232.GB31855@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304869745-1073-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 May 2011 17:49:05 +0200, Tejun Heo wrote:
> which triggers INTERRUPT trap but is sticky until the next
> PTRACE_GETSIGINFO.

PTRACE_GETSIGINFO is a getter.  It must not modify anything.  Or there should
be some other way how to query the siginfo_t state fully transparently (*).

(*) But if there exists such syscall it probably does not make sense to modify
    anything by PTRACE_GETSIGINFO.

Imagine various LD_PRELOAD tools which try to wrap system/library calls and
operate with ptrace while keeping it transparent for the original debugger.
(I have a bunch of such libraries for testing gdb/strace/etc. written there.)

Also complicated debuggers with internal OO hierarchy would need to just wrap
PTRACE_GETSIGINFO into an internal function to make it transparent for calls
not intending to modify the debuggee state.


Thanks,
Jan
