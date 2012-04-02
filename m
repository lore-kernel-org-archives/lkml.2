Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2DBFtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:49:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab2DBFt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:49:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-6-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-6-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 05/11] blackfin: fix cmpxchg build fails from system.h fallout
Date: Mon, 02 Apr 2012 06:49:15 +0100
Message-ID: <30114.1333345755@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Commit 3bed8d67469cc7129b0babc0211c32fa68408ce0
> 
>     "Disintegrate asm/system.h for Blackfin [ver #2]"
> 
> introduced arch/blackfin/include/asm/cmpxchg.h but has it also
> including the asm-generic one which causes this:
> 
>   CC      arch/blackfin/kernel/asm-offsets.s
>   In file included from arch/blackfin/include/asm/cmpxchg.h:125:0,
>                  from arch/blackfin/include/asm/atomic.h:10,
>                  from include/linux/atomic.h:4,
>                  from include/linux/spinlock.h:384,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:57,
>                  from arch/blackfin/kernel/asm-offsets.c:10:
>   include/asm-generic/cmpxchg.h:24:15: error: redefinition of '__xchg'
>   arch/blackfin/include/asm/cmpxchg.h:82:29: note: previous definition of '__xchg' was here
>   In file included from arch/blackfin/include/asm/atomic.h:10:0,
>                  from include/linux/atomic.h:4,
>                  from include/linux/spinlock.h:384,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:57,
>                  from arch/blackfin/kernel/asm-offsets.c:10:
>   arch/blackfin/include/asm/cmpxchg.h:129:0: warning: "xchg" redefined [enabled by default]
>   include/asm-generic/cmpxchg.h:81:0: note: this is the location of the previous definition
>   make[2]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1
> 
> It really only needs two simple defines from asm-generic, so just
> use those instead.
> 
> Cc: Bob Liu <lliubbo@gmail.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
