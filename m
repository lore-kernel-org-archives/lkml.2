Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0DVNLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0DVNLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:11:20 -0400
Date: Thu, 22 Apr 2010 10:11:14 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100422131113.GA3364@mothafucka.localdomain>
References: <1271675100.1674.818.camel@laptop>
 <4BCC3A3E.9070909@redhat.com>
 <20100419142158.GD14158@mothafucka.localdomain>
 <4BCC69D5.3050209@redhat.com>
 <1271688411.1488.248.camel@laptop>
 <4BCC8246.9040202@goop.org>
 <4BCD748E.7080007@redhat.com>
 <4BCDF12C.1020702@goop.org>
 <4BCDF85C.3000004@redhat.com>
 <4BCE0399.2010708@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCE0399.2010708@goop.org>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:42:17PM -0700, Jeremy Fitzhardinge wrote:
> On 04/20/2010 11:54 AM, Avi Kivity wrote:
> > On 04/20/2010 09:23 PM, Jeremy Fitzhardinge wrote:
> >> On 04/20/2010 02:31 AM, Avi Kivity wrote:
> >>   
> >>> btw, do you want this code in pvclock.c, or shall we keep it kvmclock
> >>> specific?
> >>>      
> >> I think its a pvclock-level fix.  I'd been hoping to avoid having
> >> something like this, but I think its ultimately necessary.
> >>    
> >
> > Did you observe drift on Xen, or is this "ultimately" pointing at the
> > future?
> 
> People are reporting weirdnesses that "clocksource=jiffies" apparently
> resolves.  Xen and KVM are faced with the same hardware constraints, and
> it wouldn't surprise me if there were small measurable
> non-monotonicities in the PV clock under Xen.  May as well be safe.
> 
> Of course, it kills any possibility of being able to usefully export
> this interface down to usermode.
> 
> My main concern about this kind of simple fix is that if there's a long
> term systematic drift between different CPU's tscs, then this will
> somewhat mask the problem while giving really awful time measurement on
> the "slow" CPU(s).  In that case it really needs to adjust the scaling
> factor to correct for the drift (*not* update the offset).  But if we're
> definitely only talking about fixed, relatively small time offsets then
> it is fine.
Can you by any chance run ingo's time warp test on those machines?

You need to define TOD to 1, and leave out the TSC test.

For me, warps exists on every machine out there, but the nehalems, so far
