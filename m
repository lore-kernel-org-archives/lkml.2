Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2K0ONZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:13:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45408 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2K0ONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:13:25 -0500
Date: Tue, 27 Nov 2012 14:12:23 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <Mark.Rutland@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] perf tools: fix build for various architectures
Message-ID: <20121127141223.GD16122@mudshark.cambridge.arm.com>
References: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 12:16:31PM +0000, Mark Rutland wrote:
> The UAPI changes broke the perf tool, and as of 3.7-rc7, it
> still won't build for arm:
> 
> 	In file included from util/../perf.h:81:0,
> 			 from util/cache.h:7,
> 			 from perf.c:12:
> 	util/../../../arch/arm/include/asm/unistd.h:16:29: fatal error: uapi/asm/unistd.h: No such file or directory
> 	compilation terminated.
> 	make: *** [perf.o] Error 1
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

For the arm/arm64 parts:

  Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
