Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1KSNJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 08:09:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48952 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1KSNJX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 08:09:23 -0500
MIME-Version: 1.0
In-Reply-To: <1321467575.4181.36.camel@frodo>
References: <1321467575.4181.36.camel@frodo>
Date: Sat, 19 Nov 2011 14:09:22 +0100
X-Google-Sender-Auth: kpe5larlI1mMvOefXhT4E4n23Ns
Message-ID: <CAONaPpF_urAKGRLy2Xv4ZXfDd7gT11jhdeOHpT2rjG42KW8Pcw@mail.gmail.com>
Subject: Re: [PATCH][RT] tracing: Show padding as unsigned short
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 7:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> RT added two bytes to trace migrate disable counting to the trace events
> and used two bytes of the padding to make the change. The structures and
> all were updated correctly, but the display in the event formats was
> not:
>
> cat /debug/tracing/events/sched/sched_switch/format
>
> name: sched_switch
> ID: 51
> format:
>        field:unsigned short common_type;       offset:0;       size:2; signed:0;
>        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>        field:int common_pid;   offset:4;       size:4; signed:1;
>        field:unsigned short common_migrate_disable;    offset:8;       size:2; signed:0;
>        field:int common_padding;       offset:10;      size:2; signed:0;
>
>
> The field for common_padding has the correct size and offset, but the
> use of "int" might confuse some parsers (and people that are reading
> it). This needs to be changed to "unsigned short".
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 37d3ffb..c71844c 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -117,7 +117,7 @@ static int trace_define_common_fields(void)
>        __common_field(unsigned char, preempt_count);
>        __common_field(int, pid);
>        __common_field(unsigned short, migrate_disable);
> -       __common_field(int, padding);
> +       __common_field(unsigned short, padding);
>
>        return ret;
>  }
>

This one should also be included in 3.0.9-rt26
Thanks

John Kacur
