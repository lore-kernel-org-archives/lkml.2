Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2ITHKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:10:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64430 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2ITHKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:10:13 -0400
Date: Thu, 20 Sep 2012 09:10:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] audit: Use a tracepoint for getname
Message-ID: <20120920071008.GB2042@gmail.com>
References: <20120919225659.GA11325@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919225659.GA11325@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Al, Eric,
> 
> 	Was this considered before? Acceptable?
> 
> - Arnaldo
> 
> ---
> 
> Instead of an explicit hook only for audit, use a tracepoint, so that
> other users that need to know about filenames can hook there just like
> audit.
> 
> Based on an earlier patch by Thomas Gleixner that added the tracepoint
> but left the audit_getname call.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  fs/namei.c                 |    5 ++++-
>  include/linux/audit.h      |    6 +-----
>  include/trace/events/vfs.h |   32 ++++++++++++++++++++++++++++++++
>  init/Kconfig               |    2 +-
>  kernel/audit.c             |   11 +++++++++++
>  5 files changed, 49 insertions(+), 7 deletions(-)
>  create mode 100644 include/trace/events/vfs.h

Nice generalization and we gain a useful tracepoint as well.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
