Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2ASMXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:23:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab2ASMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:23:07 -0500
Date: Thu, 19 Jan 2012 13:22:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
Message-ID: <20120119122254.GB3936@elte.hu>
References: <20120118195340.767928915@goodmis.org>
 <20120118195926.797694014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118195926.797694014@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Have the jump labels add a "jmp" in the assembly instead
> of a default nop. This will cause the assembler to put in
> either a 2 byte or 5 byte jmp depending on where the target
> lable is.
> 
> Then at compile time, the update_jump_label code will replace
> the jmps with either 2 or 5 byte nops.
> 
> On boot up, the code can be examined to see if the jump label
> uses either a 2 or 5 byte nop and replace it.
> 
> By allowing the jump labels to be 2 bytes, it speeds up the
> nops, not only 2 byte nops are faster than 5 byte nops, but also
> because it saves on cache foot print.
> 
>    text    data     bss     dec     hex filename
> 13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
> 13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new
> 
> Converting the current v3.2 trace points saved 5,131 bytes.
> As more places use jump labels, this will have a bigger savings.

Yummie!

This is very nice, as that's 5K saved from rather hot codepaths 
quite often, so this feature increases the effective instruction 
cache size of the CPU in essence.

Thanks,

	Ingo
