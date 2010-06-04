Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0FDPH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:07:56 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53835 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0FDPHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:07:54 -0400
Date: Fri, 4 Jun 2010 17:07:38 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Swetland <swetland@google.com>,
       tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604170738.75c7436e@schatten.dmk.lab>
In-Reply-To: <1275661446.4455.33.camel@mulgrave.site>
References: <20100603193045.GA7188@elte.hu>
	<AANLkTinsOF3wnxsruR0TvjBAQcHks4tf0ay_sM2xB_p4@mail.gmail.com>
	<20100604075722.GA15181@elte.hu>
	<AANLkTiksGnpL8tkcc5eScWHrGoijyZNUwZik5lXmU_TS@mail.gmail.com>
	<20100604085513.GE15181@elte.hu>
	<AANLkTinphtxn-8pGTYv_mBxKFMa7jU8i1yNbHrs50Vzl@mail.gmail.com>
	<20100604095917.GA3324@elte.hu>
	<1275661446.4455.33.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jun 2010 09:24:06 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Fri, 2010-06-04 at 11:59 +0200, Ingo Molnar wrote:
> > Anyway, i'm not pessimistic at all: _some_ sort of scheme appears to be 
> > crystalising out today. Everyone seems to agree now that the main usecases are 
> > indeed useful and need handling one way or another - the rest is really just 
> > technological discussions how to achieve the mostly-agreed-upon end goal.
> 
> It's still not clear to me whether everyone's revolving around to using
> the current suspend block API because it's orthogonal to all other
> mechanisms and is therefore separate from the kernel (and can be
> compiled out if you don't want it).  Or whether re-expressing what the
> android drivers want (minimum idle states and suspend block) in pm_qos
> terms which others can use is the way to go.  I think the latter, but
> I'd like to know what other people think (because I'm not wedded to this
> preference).

I'd like to know that also. 
I have a patch to add pm_qos_add_request_nonblock function, so it is
possible to register an pm_qos constraint by passing preallocated
memory to it. 

Notifying should be possible to do from atomic contexts via
async_schedule()?

The scalability issues of pm_qos can be adressed by using plists for
all pm_qos_class'es. Or by having the different pm_qos_class'es provide
their own implementations for the update and get operations. 

Cheers,
Flo

> 
> James
> 
