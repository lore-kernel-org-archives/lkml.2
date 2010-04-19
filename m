Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0DSOWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:22:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab0DSOWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:22:07 -0400
Date: Mon, 19 Apr 2010 11:21:58 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100419142158.GD14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <4BC8CA52.4090703@goop.org>
 <1271673545.1674.743.camel@laptop>
 <4BCC3584.1050501@redhat.com>
 <1271675100.1674.818.camel@laptop>
 <4BCC3A3E.9070909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCC3A3E.9070909@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 02:10:54PM +0300, Avi Kivity wrote:
> On 04/19/2010 02:05 PM, Peter Zijlstra wrote:
> >>
> >>>ACCESS_ONCE() is your friend.
> >>>
> >>I think it's implied with atomic64_read().
> >Yes it would be. I was merely trying to point out that
> >
> >   last = ACCESS_ONCE(last_value);
> >
> >Is a narrower way of writing:
> >
> >   last = last_value;
> >   barrier();
> >
> >In that it need not clobber all memory locations and makes it instantly
> >clear what we want the barrier for.
> 
> Oh yes, just trying to avoid a patch with both atomic64_read() and
> ACCESS_ONCE().
you're mixing the private version of the patch you saw with this one.
there isn't any atomic reads in here. I'll use a barrier then

