Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1EPS2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:28:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab1EPS2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:28:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 6/6][RFC] PM / Domains: Support for multiple generic power domain states
Date: Mon, 16 May 2011 20:29:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105160138.10431.rjw@sisk.pl> <87sjsfdklw.fsf@ti.com>
In-Reply-To: <87sjsfdklw.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105162029.18615.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 16, 2011, Kevin Hilman wrote:
> Hi Rafael,
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Allow the generic power domains support code to handle power
> > domains with multiple states.  
> 
> Thanks!

No problem. :-)

> Before I even had the time to respond to you about my previous request
> for this kind of feature, you've already implmented it. :)  

Well, I had the idea how to implement it right after I had replied to
your previous message.  The only problem was to find the time to actually
prepare a patch.

> > Replace the .power_down_ok()
> > callback in struct dev_power_governor with a new callback
> > .choose_state() that will return the number of the state to put the
> > power domain into.  Add new fields nr_states and current_state to
> > struct generic_power_domain with the assumption that state 0 will be
> > the full power state and states 1 through (nr_states - 1) will be low
> > power.  
> > Replace power domain callbacks .power_off() and .power_on()
> > with a single .set_state() callback taking the number of the state
> > to put the power domain into as its second argument.  Add a new
> > generic power domain callback .power_off_state() (taking a state
> > number as its second argument) allowing the core to check if
> > device runtime PM callbacks need to be executed before putting the
> > given power domain into the given state.  Modify the core power
> > domains code and the ARM shmobile platform code to take all of the
> > above changes into account.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Reviewed-by: Kevin Hilman <khilman@ti.com>

Thanks!

> This looks like a better starting point for more complicated hardware.

I agree.

Rafael
