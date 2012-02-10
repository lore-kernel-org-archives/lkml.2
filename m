Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab2BJR0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2BJR0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:26:03 -0500
Date: Fri, 10 Feb 2012 18:19:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ptrace: renumber PTRACE_EVENT_STOP so that future
	new options and events can match
Message-ID: <20120210171930.GC8908@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <1328884991-23889-2-git-send-email-vda.linux@googlemail.com> <1328884991-23889-3-git-send-email-vda.linux@googlemail.com> <1328884991-23889-4-git-send-email-vda.linux@googlemail.com> <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Denys Vlasenko wrote:
>
> PTRACE_EVENT_foo and PTRACE_O_TRACEfoo used to match.
> 
> New PTRACE_EVENT_STOP is the first event which has no corresponding
> PTRACE_O_TRACE option. If we will ever want to add another such option,
> its PTRACE_EVENT's value will collide with PTRACE_EVENT_STOP's value.
> 
> This patch changes PTRACE_EVENT_STOP value to prevent this.
> 
> While at it, added a comment - the one atop PTRACE_EVENT block,
> saying "Wait extended result codes for the above trace options",
> is not true for PTRACE_EVENT_STOP.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

IIRC Tejun agreed with this change too.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> ---
>  include/linux/ptrace.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index 06be6a3..ec6571c 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -61,7 +61,8 @@
>  #define PTRACE_EVENT_EXEC	4
>  #define PTRACE_EVENT_VFORK_DONE	5
>  #define PTRACE_EVENT_EXIT	6
> -#define PTRACE_EVENT_STOP	7
> +/* Extended result codes which enabled by means other than options.  */
> +#define PTRACE_EVENT_STOP	128
>  
>  /* options set using PTRACE_SETOPTIONS */
>  #define PTRACE_O_TRACESYSGOOD	1
> -- 
> 1.7.7.6
> 

