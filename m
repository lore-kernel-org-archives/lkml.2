Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2CYSLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:11:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56581 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab2CYSLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <1332597305.12799.2.camel@acer.local.home>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	<1332531400.23924.71.camel@gandalf.stny.rr.com>
	<CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
	<1332597305.12799.2.camel@acer.local.home>
Date: Sun, 25 Mar 2012 23:41:49 +0530
Message-ID: <CA+jqyFCGAtpTKpOsMwFnbDVuUC0O5jcEG+kRG3NFC8+8OznVmw@mail.gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thanks a lot for you feedback.

- Rajesh

On Sat, Mar 24, 2012 at 7:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2012-03-24 at 09:47 +0530, Rajesh Bhagat wrote:
>> Hi Steven,
>>
>> Thanks for the reply.
>>
>> I was wondering, why would a user reset the trace __explicitly__
>> without even using it.
>> That is why i created a patch for it.
>>
>> >> /debug/tracing # echo function > current_tracer
>      ^
>      |
>   user starts using tracer
>
>> >> /debug/tracing # cat trace <------ Not performed
>> >> /debug/tracing # echo schedule > set_ftrace_filter
>> >> /debug/tracing # echo function > current_trace
>> >> /debug/tracing # cat trace <------- Only this is performed
>
> Why the first "echo function"? That means you just started using the
> tracer. You can (and should) do:
>
>        # echo schedule > set_ftrace_filter
>        # echo function > current_tracer
>
> This IIRC is the documented way of using it.
>
> That said, I may consider taking the patch, as another way of resetting
> the tracer. I have to see what workflows it will affect first.
>
> -- Steve
>
>
