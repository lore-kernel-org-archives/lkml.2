Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0JPCJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:09:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0JPCJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:09:05 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=oxfdMyKVvtIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4ygZsKZSzpjnLENBWhcA:9 a=m_kzBTd7mtMYG9Mk9bIA:7 a=vwJMCOI6rHpkYf64OroTVPF4gxkA:4 a=PUjeQqilurYA:10 a=3fnNVC67pfuRrqLZ:21 a=bAfJD-BQkgxZctko:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/9] jump label: Fix module __init section race
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101015201036.445509790@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.445509790@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 22:09:02 -0400
Message-ID: <1287194942.16971.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:

> --- a/kernel/jump_label.c
> +++ b/kernel/jump_label.c
> @@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
>  			count = e_module->nr_entries;
>  			iter = e_module->table;
>  			while (count--) {
> -				if (kernel_text_address(iter->code))
> +				if (iter->key &&
> +						kernel_text_address(iter->code))

Peter, I know you hated this, but the alternative is either:

				if (iter->key &&
				    kernel_text_address(iter->code))

or break 80 chars. All three seem bad (although I don't mind breaking 80
chars for this). But I'll leave it for now.

-- Steve

>  					arch_jump_label_transform(iter, type);
>  				iter++;
>  			}
> @@ -366,6 +367,39 @@ static void remove_jump_label_module(struct module *mod)
>  	}
>  }


