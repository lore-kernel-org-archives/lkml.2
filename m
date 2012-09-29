Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2I2DP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 23:15:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2I2DPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 23:15:55 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wzlpjndgo3oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=FfOpIHPiV7sA:10 a=md3zbW8k98vbUrpas_UA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348888554.22822.108.camel@gandalf.local.home>
Subject: Re: [PATCH v3 1/3] tracing,x86: add a TSC trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 28 Sep 2012 23:15:54 -0400
In-Reply-To: <1348181550-21931-1-git-send-email-dhsharp@google.com>
References: <1348148044.13080.59.camel@gandalf.local.home>
	 <1348181550-21931-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 15:52 -0700, David Sharp wrote:

> diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_clock.h
> new file mode 100644
> index 0000000..6726f1b
> --- /dev/null
> +++ b/include/asm-generic/trace_clock.h
> @@ -0,0 +1,16 @@
> +#ifndef _ASM_GENERIC_TRACE_CLOCK_H
> +#define _ASM_GENERIC_TRACE_CLOCK_H
> +/*
> + * Arch-specific trace clocks.
> + */
> +
> +/*
> + * Additional trace clocks added to the trace_clocks
> + * array in kernel/trace/trace.c
> + * None if the architecture has not defined it.
> + */
> +#ifndef ARCH_TRACE_CLOCKS
> +# define ARCH_TRACE_CLOCKS
> +#endif
> +
> +#endif  /* _ASM_GENERIC_TRACE_CLOCK_H */

Unfortunately this isn't enough. You need to add a stub in all
arch/*/include/asm/ directories. That has:

--- trace_clock.h:
#ifndef _ASM_TRACE_CLOCK_H
#define _ASM_TRACE_CLOCK_H

#include <asm-generic/trace_clock.h>

#endif
---


Because running this against my cross-compile test, failed on all archs
but x86.

-- Steve


