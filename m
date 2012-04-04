Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2DDJqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:46:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36131 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2DDJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:46:09 -0400
Date: Wed, 4 Apr 2012 11:46:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Fix perf build failure on glibc trunk
Message-ID: <20120404094604.GA5930@gmail.com>
References: <20120404084527.GA294@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120404084527.GA294@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On a system running glibc trunk perf doesn't build:
> 
>     CC builtin-sched.o
> builtin-sched.c: In function ‘get_cpu_usage_nsec_parent’:
> builtin-sched.c:399:16: error: storage size of ‘ru’ isn’t known
> builtin-sched.c:403:2: error: implicit declaration of function ‘getrusage’ [-Werror=implicit-function-declaration]
> builtin-sched.c:403:2: error: nested extern declaration of ‘getrusage’ [-Werror=nested-externs]
> builtin-sched.c:403:18: error: ‘RUSAGE_SELF’ undeclared (first use in this function)
> builtin-sched.c:403:18: note: each undeclared identifier is reported only once for each function it appears in
> builtin-sched.c:399:16: error: unused variable ‘ru’ [-Werror=unused-variable]
> cc1: all warnings being treated as errors
> 
> Fix it by including sys/resource.h.
> ---
>  tools/perf/builtin-sched.c |    1 +
>  1 file changed, 1 insertion(+)

Can I add:

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

?

Thanks,

	Ingo
