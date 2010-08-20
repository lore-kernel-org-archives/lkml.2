Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0HTGny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:43:54 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:56030 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0HTGnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:43:52 -0400
Date: Fri, 20 Aug 2010 08:43:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@au.ibm.com, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] rwsem: Move powerpc atomic-long based
	implementation to asm-generic
Message-ID: <20100820064348.GA19989@merkur.ravnborg.org>
References: <1282107803.22370.173.camel@pasglop> <20100817.222818.193699062.davem@davemloft.net> <1282195403.22370.296.camel@pasglop> <20100818.222925.233689776.davem@davemloft.net> <1282281295.22370.401.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282281295.22370.401.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/asm-generic/rwsem-cmpxchg.h b/include/asm-generic/rwsem-cmpxchg.h
> new file mode 100644
> index 0000000..2b1c859
> --- /dev/null
> +++ b/include/asm-generic/rwsem-cmpxchg.h
> @@ -0,0 +1,183 @@
> +#ifndef _RWSEM_CMPXCHG_H
> +#define _RWSEM_CMPXCHG_H
> +
> +#ifndef _LINUX_RWSEM_H
> +#error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
> +#endif
> +
> +#ifdef __KERNEL__

#ifdef __KERNEL__ is only relevant for exported headers.
For kernel only headers like this is does not make sense,
but it does not harm.

	Sam
