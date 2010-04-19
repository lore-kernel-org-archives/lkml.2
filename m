Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0DSO0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0DSO02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:26:28 -0400
Date: Mon, 19 Apr 2010 11:26:24 -0300
From: Glauber Costa <glommer@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100419142624.GE14158@mothafucka.localdomain>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <4BC8CA52.4090703@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC8CA52.4090703@goop.org>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:36:34PM -0700, Jeremy Fitzhardinge wrote:
> On 04/15/2010 11:37 AM, Glauber Costa wrote:
> > In recent stress tests, it was found that pvclock-based systems
> > could seriously warp in smp systems. Using ingo's time-warp-test.c,
> > I could trigger a scenario as bad as 1.5mi warps a minute in some systems.
> >   
> 
> Is that "1.5 million"?
Yes it is.

But as I said, this seem to be a very deep worst case scenario. Most of boxes
are not even close to being that bad.

> 
> > (to be fair, it wasn't that bad in most of them). Investigating further, I
> > found out that such warps were caused by the very offset-based calculation
> > pvclock is based on.
> >   
> 
> Is the problem that the tscs are starting out of sync, or that they're
> drifting relative to each other over time?  Do the problems become worse
> the longer the uptime?  How large are the offsets we're talking about here?
The offsets usually seem pretty small, under a microsecond. So I don't think
it has anything to do with tscs starting out of sync. Specially because the
delta-based calculation has the exact purpose of handling that case.


