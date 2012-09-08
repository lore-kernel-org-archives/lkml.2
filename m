Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763Ab2IHBYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:24:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61367 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHBYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:24:23 -0400
MIME-Version: 1.0
In-Reply-To: <1346842839.2461.13.camel@laptop>
References: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
 <1346842839.2461.13.camel@laptop>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Sat, 8 Sep 2012 04:24:02 +0300
Message-ID: <CANg8OWK8ee97D+SkR+7DzXdJLsDgViLO3QiAcXsBnU6F_cj5wA@mail.gmail.com>
Subject: Re: [PATCH] perf bench: fix assert when NDEBUG is defined
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Its valid (although admittedly dubious) to have BUG_ON with
> side-effects.
>
> The 'right' fix would be something like:
>
> ---
>  #ifndef BUG_ON
> +#ifdef NDEBUG
> +#define BUG_ON(cond) do { if (cond) ; } while (0)
> +#else
>  #define BUG_ON(cond) assert(!(cond))
>  #endif
> +#endif
>

This is indeed the right fix. I will use this approach, test it and resubmit.

Thanks,
Irina
