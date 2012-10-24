Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2JXJJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:09:37 -0400
Received: from honeysuckle.london.02.net ([87.194.255.144]:55643 "EHLO
	honeysuckle.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2JXJJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:09:35 -0400
From: Matthew Leach <matthew@mattleach.net>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org,
        Martin =?utf-8?Q?P=C3=A4rtel?= <martin.partel@gmail.com>
Subject: Re: [REGRESSION] uml: signal.c build errors
References: <87pq48lqut.fsf@mattleach.net> <5087A203.4060505@nod.at>
Date: Wed, 24 Oct 2012 10:09:19 +0100
In-Reply-To: <5087A203.4060505@nod.at> (Richard Weinberger's message of "Wed,
	24 Oct 2012 10:08:35 +0200")
Message-ID: <87txtkgrsw.fsf@mattleach.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Richard Weinberger <richard@nod.at> writes:
>
> Does this patch fix the issue?

Your patch fixed the initial error, but I now get:

  CC      arch/um/os-Linux/signal.o
arch/um/os-Linux/signal.c:19:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:19:2: warning: (near initialization for ‘sig_info[5]’) [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:20:2: warning: (near initialization for ‘sig_info[8]’) [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:21:2: warning: (near initialization for ‘sig_info[4]’) [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:22:2: warning: (near initialization for ‘sig_info[28]’) [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:23:2: warning: (near initialization for ‘sig_info[7]’) [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:24:2: warning: (near initialization for ‘sig_info[11]’) [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:25:2: warning: (near initialization for ‘sig_info[29]’) [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:26:2: warning: (near initialization for ‘sig_info[26]’) [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: initialization from incompatible pointer type [enabled by default]
arch/um/os-Linux/signal.c:133:1: warning: (near initialization for ‘handlers[26]’) [enabled by default]
  CC      arch/um/os-Linux/start_up.o
arch/um/os-Linux/start_up.c: In function ‘check_coredump_limit’:
arch/um/os-Linux/start_up.c:338:16: error: storage size of ‘lim’ isn’t known
arch/um/os-Linux/start_up.c:339:2: error: implicit declaration of function ‘getrlimit’ [-Werror=implicit-function-declaration]
arch/um/os-Linux/start_up.c:339:22: error: ‘RLIMIT_CORE’ undeclared (first use in this function)
arch/um/os-Linux/start_up.c:339:22: note: each undeclared identifier is reported only once for each function it appears in
arch/um/os-Linux/start_up.c:347:22: error: ‘RLIM_INFINITY’ undeclared (first use in this function)
arch/um/os-Linux/start_up.c:338:16: warning: unused variable ‘lim’ [-Wunused-variable]
cc1: some warnings being treated as errors
make[1]: *** [arch/um/os-Linux/start_up.o] Error 1
make: *** [arch/um/os-Linux] Error 2


> Are you using glibc 2.17?

I am using glibc 2.16 with gcc 4.7.2.

Thanks,
Matt
