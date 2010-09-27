Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab0I0P3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759571Ab0I0P33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:29:29 -0400
Date: Mon, 27 Sep 2010 11:29:16 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
Message-ID: <20100927152916.GZ26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-4-git-send-email-ying.huang@intel.com>
 <20100927094136.GB32222@erda.amd.com>
 <AANLkTimTg1uqXdAJ+GyZ3_B6n2xKWdqFL96jvv18JBM+@mail.gmail.com>
 <20100927132537.GO13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927132537.GO13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:25:38PM +0200, Robert Richter wrote:
> On 27.09.10 08:39:24, huang ying wrote:
> 
> Looking at all you comments below I would vote for the following:
> 
> We implement all handlers using DIE_NMI and set its priority
> accordingly in struct notifier_block when registering the the nmi
> handler. We define NMI priorities as macros such as
> NMI_PRIORITY_LOCAL, NMI_PRIORITY_WATCHDOG, NMI_PRIORITY_IO, etc. and
> require all handlers to set the priority. register_die_notifier() with
> (!nb->priority) should return -EINVAL. DIE_NMI_UNKNOWN should only be
> used if there is a handler for the case when all others fail such as
> implemented in the perf nmi handler or when reporting an unknown nmi.
> 
> This will avoid all the confusion below and also makes the code much
> cleaner.

This could be interesting and certainly simplify things (processing the
die_chain once, instead of 4 times I think).  But I would probably
recommend we do this as another patch on top of Huang's to layer the
changes in a way that we can easily bisect where things went wrong if
NMIs start mis-behaving.

I don't think any of the handlers really used the priority, except for
perf, which tried to be on the bottom of the list.  So assigning
priorities like this may work.

Cheers,
Don
