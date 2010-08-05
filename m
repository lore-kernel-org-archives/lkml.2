Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab0HEOY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:24:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:54244 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558Ab0HEOYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:24:24 -0400
Date: Thu, 5 Aug 2010 07:22:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100805134057.GB20565@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008050717260.25170@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804205654.GA4986@srcf.ucam.org> <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com> <201008050220.51805.rjw@sisk.pl> <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
 <20100805134057.GB20565@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 06:02:28PM -0700, Arve Hj?nnev?g wrote:
>
>> Which makes the driver and/or network stack changes identical to using
>> wakelocks, right?
>
> I think we're resigned to the fact that we need to indicate wakeup
> events in a manner that's pretty equivalent to wakelocks. The only real
> issue is what the API looks like. Anyone who's still talking about
> cgroups seems to be trying to solve a different problem.

Ok, it is now sounding to me like there are two different (but somewhat 
related) purposes that wakelocks are being used for

1. deciding if the system should go to sleep now or not (what most of the 
discussion has been about)

2. narrowing the race between going to sleep and wakeup events.

I'm not sure it's possible to completely eliminate the race, even with 
wakelocks there is some time between the time you last check if the 
wakelock is set and when the hardware finishes responding to your commands 
to go to sleep (Unless you can set a level-based interrupt that will wake 
you up as soon as you finish going to sleep)

David Lang
