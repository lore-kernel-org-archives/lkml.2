Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2HQOET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:04:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46489 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2HQOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1345211714.3708.24.camel@gandalf.local.home>
References: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
	<1345151883.3708.7.camel@gandalf.local.home>
	<CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
	<1345211714.3708.24.camel@gandalf.local.home>
Date: Fri, 17 Aug 2012 11:04:07 -0300
Message-ID: <CALF0-+VbJmAr0j-84sZM3Di2Ar-qAOn_SFuwW1sbd_-1hoojNg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, lizefan@huawei.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2012-08-17 at 08:01 -0300, Ezequiel Garcia wrote:
>
>> Regarding the 'complete solution': to be able to capture events from
>> the very beggining...
>> Have you thought about this?
>> Could you give me a hint on how could I implement it?
>
> How far in the "beginning"? Before memory is set up?

Yes.

> I wouldn't do that.

Yeah, perhaps it sounds crazy. It makes some sense for kmem events, though.

> I have in the past (set up before memory was finished being
> initialized), but things have changed since then.
>
> One thing that we could do for those that want really early tracing, is
> to add a config option to add a static temporary ring buffer, that gets

Yes, something like this would be ideal. How would this ring buffer be
allocated?
Perhaps as static and __initdata?
This way it would be released afterwards, right?

> copied into the default ring buffer after memory is set up. That may be
> the easiest way.
>
> Once memory is set up, the ring buffer can be allocated and events can
> be traced, but the ring buffer needs to be set up first. All it would
> take is some calls in init/main.c start_kernel() to the initialization.
>

Note that my main concern is on trace_events (kmem events to be precise).
However this are registered through tracepoints and in turn this tracepoints
depend on kmalloc and friends. So, right now is a chicken-egg problem.

Thanks,
Ezequiel.
