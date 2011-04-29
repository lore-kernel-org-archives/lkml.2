Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab1D2U0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:26:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:51828 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1D2U0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:26:08 -0400
Date: Fri, 29 Apr 2011 22:26:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] trace: Add x86 irq vector entry/exit tracepoints
In-Reply-To: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.LFD.2.02.1104292218320.3005@ionos>
References: <1303774907-13099-1-git-send-email-vnagarnaik@google.com> <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Vaibhav Nagarnaik wrote:

> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 4b4c7d9..b70383e 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -139,6 +139,51 @@ DEFINE_EVENT(softirq, softirq_raise,
>  	TP_ARGS(vec_nr)
>  );
>  
> +#include <asm/irq_vectors.h>

And how is that supposed to compile on anything else than arch/x86 and
arch/um ? And no, we don't want an #ifdef x86 for that.

Thanks,

	tglx
