Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1IZQrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:47:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33935 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1IZQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:47:12 -0400
Date: Mon, 26 Sep 2011 09:32:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
Message-ID: <20110926163231.GD2399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
 <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
 <1317033884.9084.79.camel@twins>
 <20110926160205.GB2399@linux.vnet.ibm.com>
 <1317053207.1763.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317053207.1763.30.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092616-5112-0000-0000-0000009C2D03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 06:06:47PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-26 at 09:02 -0700, Paul E. McKenney wrote:
> > Would your readability concerns be addressed by something like the
> > following?
> > 
> > #define RCU_NO_HZ_LATER 0
> > #define RCU_NO_HZ_NOW   1
> > 
> > Then we would have one of the following:
> > 
> >         tick_nohz_idle_enter(RCU_NO_HZ_LATER);
> >         tick_nohz_idle_enter(RCU_NO_HZ_NOW); 
> 
> That certainly is a lot better, except for the two different ways of
> collating NO HZ in that one line.

So perhaps RCU_NOHZ_LATER and RCU_NOHZ_NOW?

Though currently the Linux kernel drops the underscore for lower-case
"nohz" and keeps it for upper-case "NO_HZ".  Hey, it was that way when
I started messing with it many years ago!  ;-)

							Thanx, Paul

