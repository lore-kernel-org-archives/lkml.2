Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab0FBTsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:48:03 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41800 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555Ab0FBTsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:48:00 -0400
Date: Wed, 2 Jun 2010 21:47:48 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, mark.gross@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100602214748.7742e3ae@schatten.dmk.lab>
In-Reply-To: <1275491111.2799.110.camel@mulgrave.site>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<1275451342.21962.1777.camel@mulgrave.site>
	<AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	<1275491111.2799.110.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jun 2010 10:05:11 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Tue, 2010-06-01 at 21:41 -0700, Arve Hjønnevåg wrote:
> > No, they have to be two separate constraints, otherwise a constraint
> > to block suspend would override a constraint to block a low power idle
> > mode or the other way around.
> 
> Depends.  If you block the system from going into low power idle, does
> that mean you still want it to be fully suspended?
> 
> If yes, then we do have independent constraints.  If not, they have a
> hierarchy:
> 
>       * Fully Interactive (no low power idle or suspend)
>       * Partially Interactive (may go into low power idle but not
>         suspend)
>       * None (may go into low power idle or suspend)
> 
> Which is expressable as a ternary constraint.
> 
> James
> 

But unblocking suspend at the moment is independent to getting idle.
If you have the requirement to stay in the highest-idle level (i.e.
best latency you can get) that does not (currently) mean, that you can
not suspend.

To preserve that explicit fall-through while still having working
run-time-powermanagement I think the qos-constraints need to be
separated. 

<disclaimer: just from what I read>
Provided you can reach the same power state from idle, current suspend
could probably also be implemented by just the freezing part and a hint
to the idle-loop to provide accelerated fall-through to lowest power. 
</disclaimer>

At that point, you could probably merge the constraints. 

But the freezing part is also the hard part, isn't it? (I have no
idea. Thomas seems to think about cgroups for that and doing smth about the timers.)

Cheers,
Flo
