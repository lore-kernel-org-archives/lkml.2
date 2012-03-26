Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2CZSTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:19:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44669 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab2CZSTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <1332781998.23924.112.camel@gandalf.stny.rr.com>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	<1332781998.23924.112.camel@gandalf.stny.rr.com>
Date: Mon, 26 Mar 2012 23:49:12 +0530
Message-ID: <CA+jqyFAQ37m_2ipfNHmsgPd-p4ziF21guDWkur+jvJdLsLAwrQ@mail.gmail.com>
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

I'm really sorry for this. :(
I'm unable to configure git send mail yet :(
>From next time, i will send patch using git send mail ONLY.

-Rajesh

On Mon, Mar 26, 2012 at 10:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-03-21 at 11:22 +0530, Rajesh Bhagat wrote:
>
>> Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
>> ---
>>  kernel/trace/trace.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index a3f1bc5..f4fb190 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -3058,8 +3058,10 @@ static int tracing_set_tracer(const char *buf)
>>         ret = -EINVAL;
>>         goto out;
>>     }
>> -   if (t == current_trace)
>> +   if (t == current_trace) {
>> +       tracing_reset_online_cpus(tr);
>>         goto out;
>> +   }
>
> BTW, this patch has major whitespace problems. You need to fix your mail
> client. For a trivial patch like this, I can fix up, but anything else
> will become a major issue. And we do not accept attachments.
>
> -- Steve
>
>
