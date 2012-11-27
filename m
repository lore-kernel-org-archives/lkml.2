Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2K0OlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:41:20 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62367 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2K0OlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:41:19 -0500
MIME-Version: 1.0
In-Reply-To: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
References: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
Date: Tue, 27 Nov 2012 09:41:18 -0500
Message-ID: <CA+5PVA6FOTd95tN4WW8KAqD5tVsGs7TTU40zLXr2mkdPRse+mg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix build for various architectures
From: Josh Boyer <jwboyer@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 7:16 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> The UAPI changes broke the perf tool, and as of 3.7-rc7, it
> still won't build for arm:
>
>         In file included from util/../perf.h:81:0,
>                          from util/cache.h:7,
>                          from perf.c:12:
>         util/../../../arch/arm/include/asm/unistd.h:16:29: fatal error: uapi/asm/unistd.h: No such file or directory
>         compilation terminated.
>         make: *** [perf.o] Error 1
>
> It seems the perf tool build infrastructure can't map <uapi/*> paths,
> and several architectures (arm, arm64, ia64, mips, parisc, powerpc,
> s390) include <uapi/asm/unistd.h> from their <asm/unistd.h>.
>
> This patch copies 77626081: "perf tools: Fix build on sparc." in simply
> changing the path to use arch/arm/include/uapi/asm/unistd.h directly for
> all of these cases.
>
> I've tested this on arm, but I don't have the necessary toolchains to
> check the other cases.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  tools/perf/perf.h |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)

This is correct, but it shouldn't be needed.  Arnaldo has a pull request
out to Ingo that should fix the build issues on all architectures in a
more generic way.  See:

http://article.gmane.org/gmane.linux.kernel.cross-arch/15974

I'm really hoping that gets into Linus' tree ASAP or 3.7 will ship with
a broken perf on non-x86.

josh
