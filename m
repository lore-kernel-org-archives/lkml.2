Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1GAWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:04:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48270 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520Ab1GAWEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:04:24 -0400
X-Sasl-enc: 0kXVwtno9VtSAEnTcZfJawbF87BqJrTEFHE7QK/PBNqY 1309557864
Date: Fri, 1 Jul 2011 14:57:40 -0700
From: Greg KH <greg@kroah.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gnb@fmeh.org, jbaron@redhat.com, gregkh@suse.de
Subject: Re: [PATCH 01/11] dynamic_debug: allow changing of dynamic_debug
 verbosity any time
Message-ID: <20110701215740.GA13572@kroah.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-2-git-send-email-jim.cromie@gmail.com>
 <BANLkTin-t=OTpOMsZDxokbPrYeOH4iQ6vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin-t=OTpOMsZDxokbPrYeOH4iQ6vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 12:41:18PM +0200, Bart Van Assche wrote:
> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > allow changing dynamic_debug verbosity
> > at boot-time, with: dynamic_debug.verbose=1
> > or at runtime with:
> > root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose
> >
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> > ---
> >  lib/dynamic_debug.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> > index 75ca78f..a3b08d5 100644
> > --- a/lib/dynamic_debug.c
> > +++ b/lib/dynamic_debug.c
> > @@ -58,6 +58,7 @@ struct ddebug_iter {
> >  static DEFINE_MUTEX(ddebug_lock);
> >  static LIST_HEAD(ddebug_tables);
> >  static int verbose = 0;
> > +module_param(verbose, int, 0744);
> 
> Why 0744 and not 0644 ? Why to set the 'executable' bit ?

Yeah, that's wrong, Jim, care to fix this?

