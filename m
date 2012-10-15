Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2JOUjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:39:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2JOUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:39:45 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZFr9x3F9gmIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=86CsJcgIa_4A:10 a=pGLkceISAAAA:8 a=zjNUz7HO9BkxaGMPzxkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
	 <1350065376-23353-2-git-send-email-fweisbec@gmail.com>
	 <CAHkRjk7yGZmFN6GoXXBciNAQV_Mw3yz7KQs6jc34D+bVpP3pbA@mail.gmail.com>
	 <1350331329.19292.4.camel@pippen.local.home>
	 <CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Oct 2012 16:39:41 -0400
Message-ID: <1350333581.19292.10.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 22:23 +0200, Frederic Weisbecker wrote:
> 2012/10/15 Steven Rostedt <rostedt@goodmis.org>:
> > On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:
> >> On 12 October 2012 19:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
> >> > new file mode 100644
> >> > index 0000000..f1bffa2
> >> > --- /dev/null
> >> > +++ b/arch/arm/include/asm/irq_work.h
> >> > @@ -0,0 +1 @@
> >> > +#include <asm-generic/irq_work.h>
> >> > diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
> >> > new file mode 100644
> >> > index 0000000..f1bffa2
> >> > --- /dev/null
> >> > +++ b/arch/arm64/include/asm/irq_work.h
> >> > @@ -0,0 +1 @@
> >> > +#include <asm-generic/irq_work.h>
> >>
> >> Just add generic-y += irq_work.h to arch/*/include/asm/Kbuild to avoid
> >> creating new files.
> >>
> >
> > BTW, is there any rational reason that the include path lookup doesn't
> > just check for the files in include/asm-generic after looking in
> > arch/*/include/asm?
> >
> > Really, the best way would be just to add the default asm files into
> > include/asm-generic and be done with it. I hate the fact that we need to
> > touch every arch for every generic default file.
> 
> Agreed. I'm including Arnd in the conversation.

As David Howells is doing user space header work, I'll include him too.
Maybe someone can shed some light onto this.

-- Steve

> 
> >
> > I'd be willing to take a look at fixing this too, when I get a chance.
> >
> > -- Steve
> >
> >


