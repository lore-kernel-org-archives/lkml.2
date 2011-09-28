Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1I1Evb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:51:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60916 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688Ab1I1Eva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:51:30 -0400
Message-ID: <1317185489.19340.22.camel@Joe-Laptop>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Sep 2011 21:51:29 -0700
In-Reply-To: <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
	 <1316725066.29447.16.camel@Joe-Laptop>
	 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
	 <1317166589.19340.14.camel@Joe-Laptop>
	 <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.92- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 20:54 -0600, Jim Cromie wrote:
> Cleanest way is to drop the original synonym, and just use
> warn (its shorter), but that creates some churn (havent grepped to see
> how much).
> I picked what looked like least effort & fewest corner-cases.
> ICBW..

#ifndef pr_fmt_warning
#define pr_fmt_warning pr_fmt_warn
#endif

> > What did you think of avoiding all of this and
> > having __dynamic_pr_debug move the fmt pointer over
> > any initial KBUILD_MODULE ": "
> >
> > int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
> > {
> > [...]
> >        size_t modsize = strlen(descriptor->modname);
> >        if (0 == strncmp(fmt, descriptor->modname, modsize) &&
> >            0 == strncmp(fmt + modsize, ": ", 2))
> >                fmt += modsize + 2;
> >        vprintk(fmt, ...)
> > ?
> 
> I was getting to that... ;-)
> Im not crazy about it.  It feels like too much ..
> Its a runtime workaround for what I think is a
> problem in users' (or header's) #defines.

I think exactly the opposite myself.

I think all of the '#define pr_fmt(fmt) KBUILD_MODNAME ": "'
are effectivly useless and I will eventually delete them.

The printk subsystem should look up the module name and
prefix them to the printk akin to how the dynamic_debug
system does.  Except the module name should be a singleton.


