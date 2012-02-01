Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2BAInP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:43:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43127 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab2BAInO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:43:14 -0500
Date: Wed, 1 Feb 2012 09:05:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
Message-ID: <20120201080539.GA11770@elte.hu>
References: <20120128160925.275163704@goodmis.org>
 <20120130144857.GA22013@elte.hu>
 <1327936060.22710.165.camel@gandalf.stny.rr.com>
 <20120131194813.GA12074@elte.hu>
 <1328072925.5882.57.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328072925.5882.57.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 2012-01-31 at 20:48 +0100, Ingo Molnar wrote:
> 
> > Attached. (you need to run it through make oldconfig and use the 
> > defaults.)
> 
> Hmm, I'm not able to reproduce it.
> 
> Could you apply this patch and run it again. I'm interested in what was
> at the location when it tried to do the conversion.
> 
> Thanks!
> 
> -- Steve
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 6173ca6..da12264 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -58,13 +58,17 @@ static void __jump_label_transform(struct jump_entry *entry,
>  			size = JUMP_LABEL_NOP_SIZE;
>  			code.jump = 0xe9;
>  			code.offset = entry->target - (entry->code + size);
> -		} else
> +		} else {
> +			unsigned char *ins = ip;
>  			/*
>  			 * The location is not a nop that we were expecting,
>  			 * something went wrong. Crash the box, as something could be
>  			 * corrupting the kernel.
>  			 */
> +			printk("Unknown op at %pS (%02x:%02x:%02x:%02x:%02x)\n",
> +			       ip, ins[0], ins[1], ins[2], ins[3], ins[4]);
>  			BUG();
> +		}

It would be better to make this a regular commit, this kind of 
diagnostics obviously makes sense. That way i could pull in your 
updated branch for more testing.

Thanks,

	Ingo
