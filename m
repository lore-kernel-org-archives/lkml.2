Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0IUS77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:59:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51533 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0IUS75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:59:57 -0400
Date: Tue, 21 Sep 2010 11:59:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [Bug #16537] TREE_RCU hangs at boot
Message-ID: <20100921185953.GA7880@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera>
 <p44oKaOqEDM.A.AeF.EhSjMB@chimera>
 <20100920182626.GE2408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100920182626.GE2408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:26:27AM -0700, Paul E. McKenney wrote:
> On Sun, Sep 12, 2010 at 09:08:42PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16537
> > Subject		: TREE_RCU hangs at boot
> > Submitter	: Rolf Eike Beer <eike-kernel@sf-tec.de>
> > Date		: 2010-08-07 12:18 (37 days old)
> > Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I cannot reproduce this.  The function that is claimed to hang contains
> only printk()s.  I have asked the guys who can actually reproduce it
> to try a later kernel, and will let you know how this goes.
> 
> If you cannot trust printk(), who can you trust?  ;-)

It turns out that this problem is due to tab processing in the PA-RISC
firmware, which certainly explains my inability to reproduce it.  It
turns out that it is fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d9b68e5e88248bb24fd4e455588bea1d56108fd6

So we can close this regression.

Many thanks to Guy Martin <gmsoft@tuxicoman.be> for much help with
this!!!

							Thanx, Paul
