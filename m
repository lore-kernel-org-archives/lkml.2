Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1G1SYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1G1SYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:24:36 -0400
Date: Thu, 28 Jul 2011 14:24:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Subject: Re: [PATCH 03/25] dynamic_debug: use pr_debug instead of pr_info
Message-ID: <20110728182427.GD2659@redhat.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-4-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-rpXrAZ6bAtWiy+rCaWEmRCwzMmNrqsRWQChM9nkdofiw@mail.gmail.com>
 <CAJfuBxzq67UM7i+EmDzdFCWfbEPM2cGad1Ed4cfCP5+v2QVgwg@mail.gmail.com>
 <CAO+b5-qoMiuOSga_fnzMfKsGDDkBAY7oLoJK1xk+XvvbT21OwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-qoMiuOSga_fnzMfKsGDDkBAY7oLoJK1xk+XvvbT21OwQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:18:56AM +0200, Bart Van Assche wrote:
> On Wed, Jul 27, 2011 at 11:34 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> > On Tue, Jul 26, 2011 at 1:08 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> >> Changing pr_info() into pr_debug() inside the dynamic_debug
> >> implementation seems like a really bad idea to me. Such changes make
> >> it hard to find out via source code reading whether or not there is a
> >> risk that invoking one of these pr_debug() macros will cause infinite
> >> recursion.
> >
> > WRT earlier discussion (Joe, Jason):
> >
> >> I think these should be pr_debug.
> >> I know you're only using the current style.
> >>
> >> Jason, any reason these can not be converted?
> >
> > it should be ok, although we have to be careful not to use them in the
> > printing path, since that will cause a recursion.
> >
> > Also, if there is an issue with the dynamic debug code, it makes it more
> > of a pain to debug :)
> 
> With this approach enabling all debug printing in the dynamic_debug
> implementation requires both echoing into .../dynamic_debug/control
> and setting the "verbose" module parameter. That's not something I
> would call "elegant", but after all, I'm not the dynamic debug
> maintainer ...
> 
> Bart.

we certainly don't want to make ppl do both. why is the verbose param
still required?
