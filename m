Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2DYQ4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:56:21 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62237 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2DYQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:56:19 -0400
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on
 resume
From: anish kumar <anish198519851985@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120425152603.3d24547f@notabene.brown>
References: <20120425122139.512c6890@notabene.brown>
	 <20120425050919.GB27843@core.coreip.homeip.net>
	 <20120425152603.3d24547f@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 22:26:05 +0530
Message-ID: <1335372965.1571.15.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 15:26 +1000, NeilBrown wrote:
> On Tue, 24 Apr 2012 22:09:19 -0700 Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> > Hi Neil,
> > 
> > On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
> > > 
> > > If we press and release the power button before the press interrupt is
> > > handled - as can happen on resume - we lose the press event so the
> > > release event is ignored and we don't know what happened to cause the
> > > wakeup.
I didn't understand this.If power button is waking up the device then
obviously power button interrupt handler is called right?If yes then how
can we lose the press event?Is user space not ready to take the event?
May be I didn't understand it properly.Can you kindly explain?
> > 
> > What kind of latency do you observe?
> 
> When I have debugging enabled, hundreds of milliseconds.
> 
> When I don't have debugging enabled ... it doesn't tell me, but I'm fairly
> sure it is several tens of milliseconds and the button press can be quicker
> than that.
> 
> If it will help I can try to instrument the driver and get some timings.
> 
> > 
> > > 
> > > So make sure that each interrupt handled does generate an event.
> > > Because twl4030 queues interrupt events we will see two interrupts
> > > for a press-release even if we handle the first one later.  This means
> > > that such a sequence will be reported as two button presses.  This
> > > is unfortunate but is better than no button presses.
> > > Possibly we could set the PENDDIS_MASK to disable queuing of
> > > interrupts, but that might adversely affect other interrupt sources.
> > >
> > 
> > It looks like we'd have to modify every driver to ensure consistent
> > behavior as we do not have any guarantees on how long resume takes.
> > Maybe this is something that input core needs to implement?
> 
> Well if every driver is buggy....
> 
> I don't see how this could be implemented in the input core.  And even if it
> was, you'd probably need to change each driver to interact with this new
> functionality which would be much the same work as changing them to work with
> the current functionality....
> But maybe I have no imagination - if you can suggest a way that the input core
> could support this without changing the drivers, I'm happy to try it out.
> 
> Thanks,
> NeilBrown


