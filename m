Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2GJJwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:52:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:37730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2GJJwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:52:41 -0400
Message-ID: <1341913952.3462.106.camel@twins>
Subject: Re: [tip:perf/core] perf/x86: Fix USER/KERNEL tagging of samples
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 10 Jul 2012 11:52:32 +0200
In-Reply-To: <1341913846.3462.105.camel@twins>
References: <tip-xxrt0a1zronm1sm36obwc2vy@git.kernel.org>
	 <CA+55aFxY7SqwSQWuRXSg+W=ftp9FtCT1MMEqMiCi1H279Fis-A@mail.gmail.com>
	 <1341598329.7709.57.camel@twins>
	 <CA+55aFzqoz7dcUCQfSrXxX2T8=2wgWdb1H2vaBhk7V-r0uaogw@mail.gmail.com>
	 <CA+55aFw+vE4zMe1bJohLuoMDaFpqGCz6sBNRE8gkV7JOvtro0g@mail.gmail.com>
	 <1341832997.3462.41.camel@twins>
	 <CA+55aFyF-GT-BAjLCvwZPFCCKkkYz0ZznSSOYw4RVYizZhLE0g@mail.gmail.com>
	 <1341910954.3462.102.camel@twins> <1341913846.3462.105.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 11:50 +0200, Peter Zijlstra wrote:
> +       if (regs->cs != __USER32_CS && regs->cs != __USER_CS)
> +               return 0;
> +
> +       if (regs->ss != __USER32_DS && regs->ss != __USER_DS)
> +               return 0; 

Those should be return 1, they are a 32bit callchain, we just don't do
anything with it.
