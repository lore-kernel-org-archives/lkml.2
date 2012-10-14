Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2JNPiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:38:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37771 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2JNPiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:38:13 -0400
Date: Sun, 14 Oct 2012 11:38:10 -0400 (EDT)
Message-Id: <20121014.113810.1779197043813269851.davem@davemloft.net>
To: mingo@kernel.org
Cc: torvalds@linux-foundation.org, dhowells@redhat.com, paulus@samba.org,
        jaxboe@fusionio.com, tj@kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] perf: Fix UAPI fallout
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121014085617.GA22544@gmail.com>
References: <11002.1350125310@warthog.procyon.org.uk>
	<CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
	<20121014085617.GA22544@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Sun, 14 Oct 2012 10:56:17 +0200

> Find below a stab at that, lightly tested.

Thanks for doing this.

> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index a89cbbb..2762877 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -112,7 +112,7 @@ void get_term_dimensions(struct winsize *ws);
>  #include <sys/types.h>
>  #include <sys/syscall.h>
>  
> -#include "../../include/linux/perf_event.h"
> +#include "../../include/uapi/linux/perf_event.h"
>  #include "util/types.h"
>  #include <stdbool.h>
>  

Each arch stanza in this header will also need the asm/unistd.h header
path adjusted to the UAPI one.

In fact, that's the only thing that broke the build for me.
