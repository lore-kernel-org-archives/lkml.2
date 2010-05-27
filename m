Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab0E0SNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:13:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64136 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934534Ab0E0SNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GIdBR/A72ahcoWrjqAZu4wkbCS+Ik8c1tkMOutHLUMZNIN83HkZSjwf1GTTQ6m+WMV
         lMVZ36bOFwHpfTSHHhrqAAlD8DyoDbDfIbYM2o5YATJh/IjrpQTz2eTkbw9Vqbq4ILUy
         IbVFEskna01yblhR9T5XD6zEaYYjqjGExSkiA=
Date: Thu, 27 May 2010 11:13:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100527181333.GA8297@core.coreip.homeip.net>
References: <AANLkTikFwznonORd42piWZvBv3oqqSj9odC9Jaud8o3x@mail.gmail.com>
 <Pine.LNX.4.44L0.1005262044001.6349-100000@netrider.rowland.org>
 <AANLkTingAiO8dkwnInc993PTyA63rV-WRvBIRlB2ChXs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTingAiO8dkwnInc993PTyA63rV-WRvBIRlB2ChXs@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 05:52:40PM -0700, Arve Hjønnevåg wrote:
> 2010/5/26 Alan Stern <stern@rowland.harvard.edu>:
> > On Wed, 26 May 2010, Arve Hjønnevåg wrote:
> >
> >> > I must be missing something.  In Arve's patch 1/8, if the system is in
> >> > opportunistic suspend, and a wakeup event occurs but no suspend
> >> > blockers get enabled by the handler, what causes the system to go back
> >> > into suspend after the event is handled?  Isn't that a loop of some
> >> > sort?
> >> >
> >>
> >> Yes it is a loop. I think what you are missing is that it only loops
> >> repeatedly if the driver that aborts suspend does not use a suspend
> >> blocker.
> >
> > You mean "the driver that handles the wakeup event".  I was asking what
> > happened if suspend succeeded and then a wakeup occurred.  But yes, if
> > a suspend blocker is used then its release causes another suspend
> > attempt, with no looping.
> >
> >> > And even if it isn't, so what?  What's wrong with looping behavior?
> >>
> >> It is a significant power drain.
> >
> > Not in the situation I was discussing.
> >
> 
> If you meant it spend most of the time suspended, then I agree. It
> only wastes power when a driver blocks suspend by returning an error
> from its suspend hook and we are forced to loop doing no useful work.
> 

If driver refuses to suspend that means there are events that need
processing. I fail to see why it would be called "looping doing no
useful work".

-- 
Dmitry
