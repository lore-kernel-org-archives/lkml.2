Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab2EIXxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:53:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62438 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2EIXxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <1336607454.14207.221.camel@gandalf.stny.rr.com>
References: <1336605692-14509-1-git-send-email-ccross@android.com>
	<1336607454.14207.221.camel@gandalf.stny.rr.com>
Date: Wed, 9 May 2012 16:53:34 -0700
X-Google-Sender-Auth: MR27ei9f4JvIEn6gxvtYzJv2clQ
Message-ID: <CAMbhsRQ4RBbhBvvxt40qePfsDAa79-3gk-cNEjGe6AmRUi=58A@mail.gmail.com>
Subject: Re: [PATCH] trace: power: add trace_clock_set_parent
From: Colin Cross <ccross@android.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 4:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-05-09 at 16:21 -0700, Colin Cross wrote:
>> Adds a new trace event to be called from clk_set_parent.  Some
>> cpufreq drivers, including Tegra, reparent the cpu clock to a
>> slower clock while the main pll is relocking, tracing
>> clk_set_parent allows traces to show how for long the cpu is
>> running slower.
>>
>> Uses a separate TRACE_EVENT instead of the clock event class to
>> allow the event to contain string names for the child and the
>> parent.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  include/trace/events/power.h |   19 +++++++++++++++++++
>>  1 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
>> index cae9a94..2b81df6 100644
>> --- a/include/trace/events/power.h
>> +++ b/include/trace/events/power.h
>> @@ -204,6 +204,25 @@ enum {
>>       TP_ARGS(name, state, cpu_id)
>>  );
>>
>> +TRACE_EVENT(clock_set_parent,
>> +
>> +     TP_PROTO(const char *name, const char *parent_name),
>> +
>> +     TP_ARGS(name, parent_name),
>> +
>> +     TP_STRUCT__entry(
>> +             __string(       name,           name            )
>> +             __string(       parent_name,    parent_name     )
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __assign_str(name, name);
>> +             __assign_str(name, parent_name);
>
> Don't you mean: __assign_str(parent_name, parent_name); ?

Yep, just noticed that in my traces, I'll send an updated patch.
