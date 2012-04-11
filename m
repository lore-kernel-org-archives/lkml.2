Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790Ab2DKRrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:47:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46553 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759500Ab2DKRrk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:47:40 -0400
MIME-Version: 1.0
In-Reply-To: <1334158690.23924.252.camel@gandalf.stny.rr.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<1333666086-6517-3-git-send-email-fweisbec@gmail.com>
	<20120411152059.GE16257@infradead.org>
	<1334158690.23924.252.camel@gandalf.stny.rr.com>
Date: Wed, 11 Apr 2012 19:47:38 +0200
Message-ID: <CAFTL4hwRa12be7DzE-RFCaS7S+ErFCZ=QjXhkFWGduhY83PKjw@mail.gmail.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/11 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-04-11 at 12:20 -0300, Arnaldo Carvalho de Melo wrote:
>> > +int pevent_register_function(struct pevent *pevent, char *func,
>> > +                        unsigned long long addr, char *mod)
>> > +{
>> > +   struct func_list *item;
>> > +
>> > +   item = malloc_or_die(sizeof(*item));
>> > +
>> > +   item->next = pevent->funclist;
>> > +   item->func = strdup(func);
>> > +   if (mod)
>> > +           item->mod = strdup(mod);
>> > +   else
>> > +           item->mod = NULL;
>>
>> strdup can fail, and no, we shouldn't die if that happens :-)
>
> Again, this all needs to be audited. But this isn't much different than
> what perf already does with the tools/perf/util/trace-event-parse.c
>
> Thus, getting the code out can be the first step. Cleaning it up into a
> nice library the second.

I agree. This is essentially moving the existing code in perf (but an
improved version of it) to a standalone
library. This is a big problem on its own already. The big one in fact.

Improving it is certainly a necessary following up step. And in fact
this is one of
the purposes of this library: make the improvements there easier. But
I believe this
should be done incrementally, once we get the migration done.
