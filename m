Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0EYNgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:36:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65032 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0EYNgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:36:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V8iYWh3UqvpkYFmD8G2BmyRThpbN5bowlhB2Kg8WAHUlg/MwqDH9dtgM3dL4U++WkB
         nDV8lBU0NPCjtevb27B/bRDnbwtzsFllGJ+hwlpXMm5/Gl592nutLQnjvqjFgJiGq73W
         P/dgZ6ydBz5NdMGikYAfnuNUUB6RT62x1VZIo=
Date: Tue, 25 May 2010 15:36:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][GIT PULL] tracing: Add __used annotation to event
	variable
Message-ID: <20100525133600.GB5286@nowhere>
References: <1274794290.22648.209.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274794290.22648.209.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 09:31:30AM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> This fixes the warning/error on PowerPC.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       tracing: Add __used annotation to event variable
> 
> ----
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> ---------------------------
> commit 49c177461bfbedeccbab22bf3905db2f9da7f1c3
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue May 25 06:19:35 2010 -0700
> 
>     tracing: Add __used annotation to event variable
>     
>     The TRACE_EVENT() macros automate creation of trace events. To automate
>     initialization, the set up variables are loaded in a special section
>     that is read on boot up. GCC is not aware that these static variables
>     are used and will complain about them if we do not inform GCC that
>     they are indeed used.
>     
>     One of the declarations of the event element was missing a __used
>     annotation. This patch adds it.
>     
>     Reported-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 0152b86..34bead7 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -68,7 +68,7 @@
>  
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, name, proto, args)	\
> -	static struct ftrace_event_call			\
> +	static struct ftrace_event_call	__used		\
>  	__attribute__((__aligned__(4))) event_##name


Oh, I was writing the exact same patch...

In fact it appears only DEFINE_EVENT_PRINT() uses this declaration,
while before, we had various callbacks that always used it.

Anyway, thanks.

