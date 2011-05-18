Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1ERUXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:23:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37101 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1ERUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:23:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of memory for drivers
Date: Wed, 18 May 2011 22:23:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105100059.25372.rjw@sisk.pl> <201105182009.55813.Martin@lichtvoll.de> <20110518183638.GA8887@elf.ucw.cz>
In-Reply-To: <20110518183638.GA8887@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182223.55312.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, Pavel Machek wrote:
> Hi!
> 
> > > > OK, there are no comments, so my understanding is that everyone is
> > > > fine with this patch and I can add it to my linux-next branch.
> > > 
> > > Actually no, I don't like it. Yes, knob might be useful for debugging,
> > > but having it as part of official kernel interface...
> > 
> > Well I and people with similar setups it is actually quite useful. It 
> > makes the difference between does hibernate *every time* versus does not 
> > hibernate sometimes. And I don't see why it can't go again, when the issue 
> > is taken care of elsewise in the future. I think that autotuning / drivers 
> > allocating their memory via whatnot is better, but until such a mechanism 
> > is agreed, developed and included in official kernel I do think that this 
> > knob does help.
> 
> Yes, autotuning would be better, and yes, knob is useful for you now.
> 
> I'd say the knob is for debugging and should go to debugfs somewhere.
> 
> > I think missing is some documentation so that the advanced user can figure 
> > out this knob.
> 
> ...so we can easily delete the knob when it is no longer neccessary.

_If_ drivers start to allocate memory in .prepare(), the knob won't be
necessary any more and _then_ we may consider removing it.  I guess a lot
of time will pass before that happens, though. :-)

That said, I'm not sure we should recommend using it beyond the cases in which
nothing else works.

Thanks,
Rafael
