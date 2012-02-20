Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2BTHi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:38:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2BTHi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:38:58 -0500
Date: Mon, 20 Feb 2012 08:38:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkenisto@us.ibm.com, a.p.zijlstra@chello.nl, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        oleg@redhat.com, tglx@linutronix.de,
        Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Josh Stone <jistone@redhat.com>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/uprobes] uprobes/core: Clean up,  refactor and improve
 the code
Message-ID: <20120220073823.GA30810@elte.hu>
References: <tip-ewbwhb8o6navvllsauu7k07p@git.kernel.org>
 <20120220060825.GA22680@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220060825.GA22680@linux.vnet.ibm.com>
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


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> The volatiles were added to arch/x86/kernel/kprobes.c because 
> of commit 7115e3fcf45 and 315eb8a2a1b. The volatiles are 
> required because gcc 4.6 gave a warning about the asm operand 
> for test_bit.  So the same were added to 
> arch/x86/kernel/uprobes.c.

Seems like a GCC bug - a bogus warning - or does it generate bad 
code as well?

In any case, kprobes.c did it correctly, it added the volatile 
*and a comment*, pointing out that it's a GCC bug. No such 
warning was added to uprobes.c, making the volatile look 
entirely spurious.

So feel free to re-add the volatile in a followup patch, just 
make sure the GCC workaround nature is documented.

Thanks,

	Ingo
