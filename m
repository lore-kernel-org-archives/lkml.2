Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1H0N7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:59:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57572 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1H0N7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:59:38 -0400
Date: Sat, 27 Aug 2011 15:59:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 5/8] cgroups: Ability to stop res charge propagation on
 bounded ancestor
Message-ID: <20110827135932.GK3298@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <1311956010-32076-6-git-send-email-fweisbec@gmail.com>
 <4E4B2A75.8010907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4B2A75.8010907@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:41:57AM +0800, Li Zefan wrote:
> > +int res_counter_charge(struct res_counter *counter, unsigned long val,
> > +			struct res_counter **limit_fail_at)
> > +{
> > +	return res_counter_charge_until(counter, NULL, val, limit_fail_at);
> > +}
> > +
> 
> static inline in res_counter.h ?
> 
> ...
> > +void res_counter_uncharge(struct res_counter *counter, unsigned long val)
> > +{
> > +	res_counter_uncharge_until(counter, NULL, val);
> > +}
> >  
> 
> ditto.

Right, sounds better inlined.
