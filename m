Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1GTWIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:08:45 -0400
Received: from mail.perches.com ([173.55.12.10]:4213 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1GTWIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:08:45 -0400
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, bvanassche@acm.org,
        gregkh@suse.de, gnb@fmeh.org
In-Reply-To: <CAJfuBxwtgOd+JAb+P2bMY7fAOb3zmgg0eLn0JmBycLpjPK783w@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
	 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
	 <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
	 <1310430335.3550.3.camel@Joe-Laptop>
	 <CAJfuBxwtgOd+JAb+P2bMY7fAOb3zmgg0eLn0JmBycLpjPK783w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 15:08:42 -0700
Message-ID: <1311199722.1663.17.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 11:43 -0600, Jim Cromie wrote:
> On Mon, Jul 11, 2011 at 6:25 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2011-07-11 at 01:46 -0600, Jim Cromie wrote:
> >> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> > []
> >> @@ -505,7 +505,17 @@ static int ddebug_save_pending(struct ddebug_query *query,
[]
> >> +                             if (verbose)
> >> +                                     pr_info("delete pending: %s\n",
> >> +                                             show_pending_query(pq));
> > I think these should be pr_debug.
> > I know you're only using the current style.
> > Jason, any reason these can not be converted?
> one other corner case (in addition to pr_cont, which I probly should
> have addressed to you)
> +#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
> makes pr_debug unconditionally print stuff that can be
> doubled up if flags are also used.
> Ive done s/pr_info/pr_debug/ locally, when combined with:
>   ddebug_query="module dynamic_debug +pfmlt "
> lines are too long, and are redundant
> This is pretty trivial, and can be avoided by
> "dont add those flags then", but I could imagine it
> being a minor annoyance wherever both pr_debug
> and pr_info|warn|err|etc are used together.
> Perhaps pr_debug and friends should ignore pr_fmt
> under CONFIG_DYNAMIC_DEBUG ?

Better I think would be to remove __func__ from those
dynamic debug pr_fmt defines.

Actually, I think it's better to never use __func__,
but that's an argument for a different day.

I think the only reason Jason did it was to always
have __func__ printed.  If those become pr_debug
then anyone that really wants to can use +pf.

cheers, Joe

