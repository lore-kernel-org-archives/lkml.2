Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1GDM7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:59:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62203 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1GDM7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:59:42 -0400
Date: Mon, 4 Jul 2011 14:59:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/6] x86,64: Simplify save_regs()
Message-ID: <20110704125936.GC1915@somewhere.redhat.com>
References: <1309624184-9790-1-git-send-email-fweisbec@gmail.com>
 <1309624184-9790-4-git-send-email-fweisbec@gmail.com>
 <4E1185F3020000780004BF21@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1185F3020000780004BF21@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 08:20:51AM +0100, Jan Beulich wrote:
> >  ENTRY(save_rest)
> >  	PARTIAL_FRAME 1 REST_SKIP+8
> > @@ -791,7 +781,7 @@ END(interrupt)
> >  	/* reserve pt_regs for scratch regs and rbp */
> >  	subq $ORIG_RAX-RBP, %rsp
> >  	CFI_ADJUST_CFA_OFFSET ORIG_RAX-RBP
> > -	call save_args
> > +	SAVE_ARGS_IRQ
> >  	PARTIAL_FRAME 0
> 
> With the above CFI adjustments all looking correct, this PARTIAL_FRAME
> directive now is at best redundant, and hence should be removed.

Indeed, will fix.

Thanks.
