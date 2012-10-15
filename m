Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2JOUCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2JOUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:02:14 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZFr9x3F9gmIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=86CsJcgIa_4A:10 a=pGLkceISAAAA:8 a=oa-gs3B95TKaPai3Q2gA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CAHkRjk7yGZmFN6GoXXBciNAQV_Mw3yz7KQs6jc34D+bVpP3pbA@mail.gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
	 <1350065376-23353-2-git-send-email-fweisbec@gmail.com>
	 <CAHkRjk7yGZmFN6GoXXBciNAQV_Mw3yz7KQs6jc34D+bVpP3pbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Oct 2012 16:02:09 -0400
Message-ID: <1350331329.19292.4.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:
> On 12 October 2012 19:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
> > new file mode 100644
> > index 0000000..f1bffa2
> > --- /dev/null
> > +++ b/arch/arm/include/asm/irq_work.h
> > @@ -0,0 +1 @@
> > +#include <asm-generic/irq_work.h>
> > diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
> > new file mode 100644
> > index 0000000..f1bffa2
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/irq_work.h
> > @@ -0,0 +1 @@
> > +#include <asm-generic/irq_work.h>
> 
> Just add generic-y += irq_work.h to arch/*/include/asm/Kbuild to avoid
> creating new files.
> 

BTW, is there any rational reason that the include path lookup doesn't
just check for the files in include/asm-generic after looking in
arch/*/include/asm? 

Really, the best way would be just to add the default asm files into
include/asm-generic and be done with it. I hate the fact that we need to
touch every arch for every generic default file.

I'd be willing to take a look at fixing this too, when I get a chance.

-- Steve


