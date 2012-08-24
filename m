Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2HXLxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:53:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43366 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2HXLxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <1345214379.3708.29.camel@gandalf.local.home>
References: <1345043907-18299-1-git-send-email-elezegarcia@gmail.com>
	<1345151883.3708.7.camel@gandalf.local.home>
	<CALF0-+WVoJ2NTPm7xZc0rr8-ZZ6an1BsN0SLtJvxzFd3CxA6bA@mail.gmail.com>
	<1345211714.3708.24.camel@gandalf.local.home>
	<CALF0-+VbJmAr0j-84sZM3Di2Ar-qAOn_SFuwW1sbd_-1hoojNg@mail.gmail.com>
	<1345214379.3708.29.camel@gandalf.local.home>
Date: Fri, 24 Aug 2012 08:53:39 -0300
Message-ID: <CALF0-+XiJBVLRA2ja-JreDgfcrzgzcQJX+JjfB4kiHBgn2-M-g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] trace: Move trace event enable from fs_initcall
 to early_initcall
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        tim.bird@am.sony.com, lizefan@huawei.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Fri, Aug 17, 2012 at 11:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I don't think kmalloc is the issue. The big problem in front of you is
> jump labels. That's what enables and disables trace points, and it gets
> initialized just after memory is set up. You may have to force jump
> labels off when doing early tracing :-/ Although I'm not sure it
> requires allocations.
>

Well, I wasn't thinking *that* early actually. So, I'm trying to enable tracing
at some point after jump_labels (could be near perf_event_init).

Right now, the static ring buffer part is done and I'm having some
problems copying this ring buffer into the *real* one.

Mind giving me another hint?

Thanks a lot for your help so far,
Ezequiel.
