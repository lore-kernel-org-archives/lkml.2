Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0DZOCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0DZOCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:02:48 -0400
Date: Mon, 26 Apr 2010 11:01:57 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 1/4] [BUGFIX] perf tools: Initialize dso->node
	member in dso__new
Message-ID: <20100426140157.GE7460@ghostprotocols.net>
References: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421195616.24664.89980.stgit@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 21, 2010 at 03:56:16PM -0400, Masami Hiramatsu escreveu:
> If dso->node member is not initilized, it causes a segmentation
> fault when adding to other lists. It should be initilized in
> dso__new().
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  tools/perf/util/symbol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index e782e7d..e77c33a 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -189,6 +189,7 @@ struct dso *dso__new(const char *name)
>  		self->sorted_by_name = 0;
>  		self->has_build_id = 0;
>  		self->kernel = DSO_TYPE_USER;
> +		INIT_LIST_HEAD(&self->node);
>  	}
>  
>  	return self;

Trying to understand how this would be a problem, as:

static inline void __list_add(struct list_head *new,
                              struct list_head *prev,
                              struct list_head *next)
{
        next->prev = new;
        new->next = next;
        new->prev = prev;
        prev->next = new;
}

This is not a list head, just a node.

Looking at other messages where you described the problem to try to
understand why this would help.

- Arnaldo
