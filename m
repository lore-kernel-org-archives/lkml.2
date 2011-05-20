Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935192Ab1ETQaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:30:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934587Ab1ETQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:30:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105201806340.3078@ionos>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au> <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <alpine.LFD.2.02.1105201806340.3078@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 May 2011 09:29:37 -0700
Message-ID: <BANLkTi=qP3ttri7MseabgJHzx1JYfOyLaw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 9:16 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Removed it, but it does not break anything on x86 because
> linux/thread_info.h includes asm/thread_info.h which includes
> asm/processor.h on x86 for non obvious reasons.

Ahh. "mm_segment_t".

Some other architectures do it in their <asm/segment.h>

And looking at it, we could just do it in thread_info.h itself. I dunno.

At *some* point it would be really nice to try to minimize the header
files, I suspect we spend a lot of time compiling just parsing the
crud most people never need.

(In fact, from my sparse days, I pretty much guarantee that is the case)

                Linus
