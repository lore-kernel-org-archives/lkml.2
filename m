Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0JOVHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:07:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:34250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0JOVHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:07:19 -0400
Subject: Re: [PATCH 8/9] jump label: Make arch_jump_label_text_poke_early()
 optional
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
        David Daney <ddaney@caviumnetworks.com>
In-Reply-To: <20101015201037.703989993@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201037.703989993@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 23:06:55 +0200
Message-ID: <1287176815.1998.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> +
> +#ifdef HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
>  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> +#else
> +static inline void arch_jump_label_text_poke_early(jump_label_t addr) {}
> +#endif
> + 

How often is this called, do we really need to avoid that call? It looks
like init code.
