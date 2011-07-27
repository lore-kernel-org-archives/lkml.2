Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1G0JUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:20:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1G0JUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:20:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: better oopsing when frozen
Date: Wed, 27 Jul 2011 11:21:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <201107251043.19932.oneukum@suse.de> <201107270024.11194.rjw@sisk.pl> <20110726154502.14c7b51b.akpm@linux-foundation.org>
In-Reply-To: <20110726154502.14c7b51b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271121.21348.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 27, 2011, Andrew Morton wrote:
> On Wed, 27 Jul 2011 00:24:11 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > Hi Rafael,
> > > 
> > > I had a problem with the kernel stopping the machine forever because I got an
> > > oops while tasks were frozen. It seems to me that we should thaw when this
> > > happens. How about this approach?
> > 
> > Well, we do something like this already for the OOM killer (see
> > oom_killer_disable() and friends), so I think it would be better to
> > simply extend/modify that mechanism instead of adding a new one
> > doing almost exactly the same thing.
> > 
> > I have no complaints about adding thaw_in_oops(), though, so long as
> > Andrew thinks it makes sense.
> 
> mm...  The patch as proposed is very simple, direct, explicit.  I
> suspect that trying to embed this operation within some other one would
> end up producing a less clear result.  Sometimes we do exceptional and
> weird things, and leaving the code exceptional and weird-looking is
> better than hiding it in some framework, if you follow what I mean.

My point is that instead of using the oom_killer_disabled variable in
page_alloc.c, we could use a oom_killer_disabled() function returning
the value of the new tasks_are_frozen variable.  Then,
oom_killer_disable/enable() won't be necessary any more.

> It does need some code comments to explain to people what it's doing
> and more importantly why it's doing it.  Also, something which doesn't
> break the build when CONFIG_FREEZER=n would be nice.

Right.

Thanks,
Rafael
