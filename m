Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2FSKTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:19:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59594 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2FSKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:19:11 -0400
Date: Tue, 19 Jun 2012 18:27:06 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Sami Kerola <kerolasa@gmail.com>
Cc: Sami Kerola <kerolasa@iki.fi>, Jens Axboe <axboe@kernel.dk>,
        Rob Landley <rob@landley.net>,
        Bernhard Voelker <mail@bernhard-voelker.de>,
        Zheng Liu <wenqing.lz@taobao.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: [PATCH] docs: block: update ioprio.txt
Message-ID: <20120619102706.GA9273@gmail.com>
Mail-Followup-To: Sami Kerola <kerolasa@gmail.com>,
	Sami Kerola <kerolasa@iki.fi>, Jens Axboe <axboe@kernel.dk>,
	Rob Landley <rob@landley.net>,
	Bernhard Voelker <mail@bernhard-voelker.de>,
	Zheng Liu <wenqing.lz@taobao.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, util-linux@vger.kernel.org
References: <1340095897-9014-1-git-send-email-wenqing.lz@taobao.com>
 <CAG27Bk2tXprRfMfYOVdWtwSbjw5Rw9Kxs6Wns+Gm65m3hoJawg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG27Bk2tXprRfMfYOVdWtwSbjw5Rw9Kxs6Wns+Gm65m3hoJawg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sami,

[You forgot to CC'd other developers and mailing list]

On Tue, Jun 19, 2012 at 10:54:41AM +0200, Sami Kerola wrote:
> Hi Zheng,
> 
> Wouldn't a patch such as below be better?

Looks good to me.  But, IMHO, if reader cannot access Internet, my patch
maybe is better for them.  The original writer is not me.  So I don't
understand the original idea that puts ionice source code in here.  I
think that Jens can do the final decision.

Hi Jens,

What's your opintion about Sami's and my patch?

Regards,
Zheng

> 
> From 800d7d46f8c1945d9c2e43912376c9b7d00a15ba Mon Sep 17 00:00:00 2001
> From: Sami Kerola <kerolasa@iki.fi>
> Date: Tue, 19 Jun 2012 10:52:06 +0200
> Subject: [PATCH] docs: block: update ioprio.txt
> 
> Inform the ionice.c in ioprio.txt document is moved to util-linux
> package.
> 
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Rob Landley <rob@landley.net>
> CC: Bernhard Voelker <mail@bernhard-voelker.de>
> CC: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
> ---
>  Documentation/block/ioprio.txt |  126 ++--------------------------------------
>  1 file changed, 5 insertions(+), 121 deletions(-)
> 
> diff --git a/Documentation/block/ioprio.txt b/Documentation/block/ioprio.txt
> index 8ed8c59..9ccd3f0 100644
> --- a/Documentation/block/ioprio.txt
> +++ b/Documentation/block/ioprio.txt
> @@ -57,127 +57,11 @@ For a running process, you can give the pid instead:
> 
>  will change pid 100 to run at the realtime scheduling class, at priority 2.
> 
> ----> snip ionice.c tool <---
> -
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <errno.h>
> -#include <getopt.h>
> -#include <unistd.h>
> -#include <sys/ptrace.h>
> -#include <asm/unistd.h>
> -
> -extern int sys_ioprio_set(int, int, int);
> -extern int sys_ioprio_get(int, int);
> -
> -#if defined(__i386__)
> -#define __NR_ioprio_set		289
> -#define __NR_ioprio_get		290
> -#elif defined(__ppc__)
> -#define __NR_ioprio_set		273
> -#define __NR_ioprio_get		274
> -#elif defined(__x86_64__)
> -#define __NR_ioprio_set		251
> -#define __NR_ioprio_get		252
> -#elif defined(__ia64__)
> -#define __NR_ioprio_set		1274
> -#define __NR_ioprio_get		1275
> -#else
> -#error "Unsupported arch"
> -#endif
> -
> -static inline int ioprio_set(int which, int who, int ioprio)
> -{
> -	return syscall(__NR_ioprio_set, which, who, ioprio);
> -}
> -
> -static inline int ioprio_get(int which, int who)
> -{
> -	return syscall(__NR_ioprio_get, which, who);
> -}
> -
> -enum {
> -	IOPRIO_CLASS_NONE,
> -	IOPRIO_CLASS_RT,
> -	IOPRIO_CLASS_BE,
> -	IOPRIO_CLASS_IDLE,
> -};
> -
> -enum {
> -	IOPRIO_WHO_PROCESS = 1,
> -	IOPRIO_WHO_PGRP,
> -	IOPRIO_WHO_USER,
> -};
> -
> -#define IOPRIO_CLASS_SHIFT	13
> -
> -const char *to_prio[] = { "none", "realtime", "best-effort", "idle", };
> -
> -int main(int argc, char *argv[])
> -{
> -	int ioprio = 4, set = 0, ioprio_class = IOPRIO_CLASS_BE;
> -	int c, pid = 0;
> -
> -	while ((c = getopt(argc, argv, "+n:c:p:")) != EOF) {
> -		switch (c) {
> -		case 'n':
> -			ioprio = strtol(optarg, NULL, 10);
> -			set = 1;
> -			break;
> -		case 'c':
> -			ioprio_class = strtol(optarg, NULL, 10);
> -			set = 1;
> -			break;
> -		case 'p':
> -			pid = strtol(optarg, NULL, 10);
> -			break;
> -		}
> -	}
> -
> -	switch (ioprio_class) {
> -		case IOPRIO_CLASS_NONE:
> -			ioprio_class = IOPRIO_CLASS_BE;
> -			break;
> -		case IOPRIO_CLASS_RT:
> -		case IOPRIO_CLASS_BE:
> -			break;
> -		case IOPRIO_CLASS_IDLE:
> -			ioprio = 7;
> -			break;
> -		default:
> -			printf("bad prio class %d\n", ioprio_class);
> -			return 1;
> -	}
> -
> -	if (!set) {
> -		if (!pid && argv[optind])
> -			pid = strtol(argv[optind], NULL, 10);
> -
> -		ioprio = ioprio_get(IOPRIO_WHO_PROCESS, pid);
> -
> -		printf("pid=%d, %d\n", pid, ioprio);
> -
> -		if (ioprio == -1)
> -			perror("ioprio_get");
> -		else {
> -			ioprio_class = ioprio >> IOPRIO_CLASS_SHIFT;
> -			ioprio = ioprio & 0xff;
> -			printf("%s: prio %d\n", to_prio[ioprio_class], ioprio);
> -		}
> -	} else {
> -		if (ioprio_set(IOPRIO_WHO_PROCESS, pid, ioprio | ioprio_class <<
> IOPRIO_CLASS_SHIFT) == -1) {
> -			perror("ioprio_set");
> -			return 1;
> -		}
> -
> -		if (argv[optind])
> -			execvp(argv[optind], &argv[optind]);
> -	}
> -
> -	return 0;
> -}
> -
> ----> snip ionice.c tool <---
> +Tool source code
> +----------------
> 
> +Moved to util-linux package schedutils/ionice.c
> +
> +http://git.kernel.org/?p=utils/util-linux/util-linux.git;a=blob;f=schedutils/ionice.c
> 
>  March 11 2005, Jens Axboe <jens.axboe@oracle.com>
> -- 
> 1.7.9.5
