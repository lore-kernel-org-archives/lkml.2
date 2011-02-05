Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1BEBJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 20:09:07 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:56962 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BEBJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 20:09:06 -0500
Date: Fri, 4 Feb 2011 20:07:55 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Faisal Latif <faisal.latif@intel.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 1/4] lockdep, timer: Fix del_timer_sync() annotation
Message-ID: <20110205010755.GA4000@elliptictech.com>
References: <20110203140940.072679794@chello.nl>
 <20110203141548.039540914@chello.nl>
 <alpine.LFD.2.00.1102031634270.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102031634270.31804@localhost6.localdomain6>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-03 16:35 +0100, Thomas Gleixner wrote:
> On Thu, 3 Feb 2011, Peter Zijlstra wrote:
> > Calling local_bh_enable() will want to actually start processing
> > softirqs, which isn't a good idea since this can get called with IRQs
> > disabled.
> > 
> > Cure this by using _local_bh_enable() which doesn't start processing
> > softirqs, and use raw_local_irq_save() to avoid any softirqs from
> > happending without letting lockdep think IRQs are in fact disabled.
> > 
> > Reported-by: Nick Bowler <nbowler@elliptictech.com>
> 
> Nick, can you please test ?

Yes, this patch seems to solve the issue.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
