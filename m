Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2GWUcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:32:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48967 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371Ab2GWUcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <1343063384.7811.20.camel@joe2Laptop>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
 <1342727183-4520-2-git-send-email-jim.cromie@gmail.com> <20120723130759.GB28867@redhat.com>
 <1343063384.7811.20.camel@joe2Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 23 Jul 2012 14:31:49 -0600
Message-ID: <CAJfuBxxvR29xfzEhDu1WD6VjdsMJhZ5yhs0ExDiFpUpaCMPjTA@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers-core: make structured logging play nice with dynamic-debug
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, kay@vrfy.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 11:09 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-07-23 at 09:07 -0400, Jason Baron wrote:
>> On Thu, Jul 19, 2012 at 01:46:20PM -0600, Jim Cromie wrote:
>> > commit c4e00daaa96d3a0786f1f4fe6456281c60ef9a16 changed __dev_printk
>> > in a way that broke dynamic-debug's ability to control the dynamic
>> > prefix of dev_dbg(dev,..), but not dev_dbg(NULL,..) or pr_debug(..),
>> > which is why it wasnt noticed sooner.
>> >
>> > When dev==NULL, __dev_printk() just calls printk(), which just works.
>> > But otherwise, it assumed that level was always a string like "<L>"
>> > and just plucked out the 'L', ignoring the rest.  However,
>> > dynamic_emit_prefix() adds "[tid] module:func:line:" to the string,
>> > those additions all got lost.
>> >
>
> I think this is not a really good approach.
>
> 3 depths of %pV can consume quite a lot of stack
> and avoiding this is useful.
>
> I'd much rather improve/centralize the mechanism
> in dynamic_debug.c so that the extra recursion
> depth is avoided.
>
> Something like this:
>
> o Remove KERN_DEBUG from dynamic_emit_prefix
> o Make a function of create_syslog_header to format
>   the header for printk_emit.
> o Call printk_emit in dynamic_dev_dbg and dynamic_netdev_dbg
> o Call printk_emit in __dev_printk
> o Remove now unused EXPORT_SYMBOL(__netdev_printk)
> o Neatening
>
> Thoughts?
>

My patch was a minimal bug-fix aimed at rc-late, but it missed the window.
We now have room for a more comprehensive fix, such as yours.

OTOH, my patch does fix a bug, while yours is a bigger "optimization" patch.
Your commit message could identify the lost prefix as its impetus,
but I think it stands nicely on its own as a refactoring for less stack usage.

I'll try the patch soon

thanks
Jim
