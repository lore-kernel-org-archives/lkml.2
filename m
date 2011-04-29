Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009Ab1D2WFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:05:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13461 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1D2WFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hZFUSqKguECW4TYBw9E75+Ki9O3F0uh2XAwntwD8/sv/5EceHzyRMK/tTEFhWvDScq
         fwxuoMKI09JaPHMFVvCw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104292218320.3005@ionos>
References: <1303774907-13099-1-git-send-email-vnagarnaik@google.com>
 <1304107962-18576-1-git-send-email-vnagarnaik@google.com> <alpine.LFD.2.02.1104292218320.3005@ionos>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Apr 2011 15:04:35 -0700
Message-ID: <BANLkTiknxGh5ObC0U=xodswwdFjRkqkhyA@mail.gmail.com>
Subject: Re: [PATCH] trace: Add x86 irq vector entry/exit tracepoints
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 1:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 29 Apr 2011, Vaibhav Nagarnaik wrote:
>
>> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
>> index 4b4c7d9..b70383e 100644
>> --- a/include/trace/events/irq.h
>> +++ b/include/trace/events/irq.h
>> @@ -139,6 +139,51 @@ DEFINE_EVENT(softirq, softirq_raise,
>>       TP_ARGS(vec_nr)
>>  );
>>
>> +#include <asm/irq_vectors.h>
>
> And how is that supposed to compile on anything else than arch/x86 and
> arch/um ? And no, we don't want an #ifdef x86 for that.
>
You are right. I didn't think of other platforms.

If I include <asm/irq.h>, it should compile on all the platforms. What do you
think?

The other way is to define the irq_vectors as a separate trace system which
only gets initialized if the platform files create the tracepoints for it. The
only difference I see is that the tracepoints would move from under irq/ to
irq_vectors/.

> Thanks,
>
>        tglx
>


Thanks for your quick responses.

Vaibhav Nagarnaik
