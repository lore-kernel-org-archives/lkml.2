Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab1FALRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:17:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58279 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab1FALRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:17:00 -0400
X-Greylist: delayed 7385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 07:17:00 EDT
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110531014543.GU2668@linux.vnet.ibm.com>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
	 <20110530162354.GQ2668@linux.vnet.ibm.com>
	 <1306775989.2497.527.camel@laptop>
	 <20110530212833.GS2668@linux.vnet.ibm.com>
	 <1306791219.23844.12.camel@twins>
	 <20110531014543.GU2668@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Jun 2011 13:05:39 +0200
Message-ID: <1306926339.2353.191.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 18:45 -0700, Paul E. McKenney wrote:
> > > Because priority boosting doesn't help unless the callbacks also run
> > > RT priority.
> > > 
> > > I could make it so that they ran as normal tasks if !RCU_BOOST, but
> > > they would still need to run as RT tasks for RCU_BOOST.  I figured
> > > running them the same way in both cases would be simpler.
> > 
> > Ah, I thought you'd boost the threads along with the waiters, to the
> > same prio so that they wouldn't disturb higher priority tasks for no
> > reason.
> 
> I considered that, but working out when it is OK to deboost them is
> decidedly non-trivial. 

Where exactly is the problem there? The boost lasts for as long as it
takes to finish the grace period, right? There's a distinct set of
callbacks associated with each grace-period, right? In which case you
can de-boost your thread the moment you're done processing that set.

Or am I simply confused about how all this is supposed to work?
