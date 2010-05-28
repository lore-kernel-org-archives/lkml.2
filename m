Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab0E1PyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:54:07 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35768 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892Ab0E1PyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:54:04 -0400
Date: Fri, 28 May 2010 17:53:54 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5?= =?ISO-8859-15?Q?g?= 
	<arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528175354.7e6a73d1@schatten.dmk.lab>
In-Reply-To: <1275058794.27810.9571.camel@twins>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
	<20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
	<AANLkTilYHKKmQePBGW3LVLjUZy7HXHQku2Iub-LWGBm6@mail.gmail.com>
	<20100528132138.2d802d77@lxorguk.ukuu.org.uk>
	<1275049836.1645.1.camel@laptop>
	<20100528140236.3214929e@lxorguk.ukuu.org.uk>
	<1275052817.1645.64.camel@laptop>
	<1275058794.27810.9571.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 16:59:54 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> So lets look at the problem, we want to be frugal with power, this means
> that the system as a whole should strive to do nothing. And we want to
> enforce this as strict as possible.

An interesting thought might be to add the costs of staying in
a state versus going to a lower power state into consideration. 

If the system is busy doing stuff it would need to do anyway (today
stuff that is guarded/annotated by the suspend blockers) , the costs for
not being in suspend have to be paid anyway. So it is opportune for
processes to run. Even if they by themselves would not justify the
system running. 

If instead nothing system-relevant has to be done, the costs of running
anything non-relevant is the full amount of battery-life that could
be saved by suspending + (some minor) running costs. 

Also if there is much work to do (many tasks) its more likely that it's
good to do the work.

something along the lines :

(amount of energy saved by being in suspend) / (number of tasks we
would run if we werent suspended) *
some_parameter_for_this_tasks_importance (which falls clearly into
scheduler-territory)

And if this goes above some threshold we run it.

But this isn't easily done in a robust way.
Also it complicates things. 

Cheers,
Flo
