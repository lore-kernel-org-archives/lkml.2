Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0DSLFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:05:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:43827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0DSLFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:05:08 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BCC3584.1050501@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>
	 <4BCC3584.1050501@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 13:05:00 +0200
Message-ID: <1271675100.1674.818.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 13:50 +0300, Avi Kivity wrote:
> On 04/19/2010 01:39 PM, Peter Zijlstra wrote:
> > On Fri, 2010-04-16 at 13:36 -0700, Jeremy Fitzhardinge wrote:
> >    
> >>> +     do {
> >>> +             last = last_value;
> >>>
> >>>        
> >> Does this need a barrier() to prevent the compiler from re-reading
> >> last_value for the subsequent lines?  Otherwise "(ret<  last)" and
> >> "return last" could execute with different values for "last".
>     
> > ACCESS_ONCE() is your friend.
> >    
> 
> I think it's implied with atomic64_read().

Yes it would be. I was merely trying to point out that

  last = ACCESS_ONCE(last_value);

Is a narrower way of writing:

  last = last_value;
  barrier();

In that it need not clobber all memory locations and makes it instantly
clear what we want the barrier for.

