Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1H2TPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 15:15:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1H2TPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 15:15:01 -0400
Date: Mon, 29 Aug 2011 15:14:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: gregkh@suse.de, joe@perches.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] dynamic_debug: use a single printk() to emit msgs
Message-ID: <20110829191453.GA3031@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com>
 <0ad5d75e1d238d186a3beadefd9de80316409867.1314291910.git.jbaron@redhat.com>
 <CAJfuBxyyiGYJ-DmtJG2fy0HDZ6BbpYpXwnA02uetS_0RRuh+0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfuBxyyiGYJ-DmtJG2fy0HDZ6BbpYpXwnA02uetS_0RRuh+0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 03:47:49PM -0600, Jim Cromie wrote:
> On Thu, Aug 25, 2011 at 11:34 AM, Jason Baron <jbaron@redhat.com> wrote:
> 
> > +       if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
> > +               pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
> > +       if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
> > +               pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
> > +       if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
> > +               pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
> 
> this inserts a space after lineno, but not otherwize.
> 
> I have patch to fix it, but maybe you want to fix it it here ?
> 

Hi Jim,

Thanks for your fix...since Greg hasn't taken the series yet...I guess
I'll re-spin to include this fix. Probably wouldn't send it out until
tomorrow due to my test systems being down atm...

thanks,

-Jason


> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 9c8e133..122246f 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -439,7 +439,9 @@ static char *dynamic_emit_prefix(const struct
> _ddebug *desc, char *buf)
>  	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
>  		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
>  	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
> -		pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
> +		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
> +	if (pos - strlen(KERN_DEBUG))
> +		pos += snprintf(buf + pos, LEFT(pos), " ");
> 
>  	return buf;
>  }
> -- 
> 1.7.4.4
> 
> 
> also attached.
> If it doesnt apply, or you defer, I'll resend once Greg's accepted
> your whole set.

> From ec75cd50ba89bed1f0ad74b89c9a43e87b2bd767 Mon Sep 17 00:00:00 2001
> From: Jim Cromie <jim.cromie@gmail.com>
> Date: Tue, 2 Aug 2011 15:12:55 -0600
> Subject: [PATCH 03/28] dynamic_debug: add space at end of non-null
>  dynamic-prefix
> 
> dynamic_emit_prefix() currently adds a space after line-number,
> but not otherwize.  For readability, add space whenever any prefix
> (besides the "<7>" loglevel) has been written.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> ---
>  lib/dynamic_debug.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index 9c8e133..122246f 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -439,7 +439,9 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
>  	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
>  		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
>  	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
> -		pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
> +		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
> +	if (pos - strlen(KERN_DEBUG))
> +		pos += snprintf(buf + pos, LEFT(pos), " ");
>  
>  	return buf;
>  }
> -- 
> 1.7.4.4
> 

