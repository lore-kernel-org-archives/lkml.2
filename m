Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2JOUX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:23:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50415 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2JOUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <1350331329.19292.4.camel@pippen.local.home>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
	<1350065376-23353-2-git-send-email-fweisbec@gmail.com>
	<CAHkRjk7yGZmFN6GoXXBciNAQV_Mw3yz7KQs6jc34D+bVpP3pbA@mail.gmail.com>
	<1350331329.19292.4.camel@pippen.local.home>
Date: Mon, 15 Oct 2012 22:23:24 +0200
Message-ID: <CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:
>> On 12 October 2012 19:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
>> > new file mode 100644
>> > index 0000000..f1bffa2
>> > --- /dev/null
>> > +++ b/arch/arm/include/asm/irq_work.h
>> > @@ -0,0 +1 @@
>> > +#include <asm-generic/irq_work.h>
>> > diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
>> > new file mode 100644
>> > index 0000000..f1bffa2
>> > --- /dev/null
>> > +++ b/arch/arm64/include/asm/irq_work.h
>> > @@ -0,0 +1 @@
>> > +#include <asm-generic/irq_work.h>
>>
>> Just add generic-y += irq_work.h to arch/*/include/asm/Kbuild to avoid
>> creating new files.
>>
>
> BTW, is there any rational reason that the include path lookup doesn't
> just check for the files in include/asm-generic after looking in
> arch/*/include/asm?
>
> Really, the best way would be just to add the default asm files into
> include/asm-generic and be done with it. I hate the fact that we need to
> touch every arch for every generic default file.

Agreed. I'm including Arnd in the conversation.

>
> I'd be willing to take a look at fixing this too, when I get a chance.
>
> -- Steve
>
>
