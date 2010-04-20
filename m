Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0DTB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab0DTB63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:58:29 -0400
Date: Mon, 19 Apr 2010 22:57:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
Message-ID: <20100420015733.GA28249@amt.cnet>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
 <1271356648-5108-2-git-send-email-glommer@redhat.com>
 <4BC8CA52.4090703@goop.org>
 <20100419142624.GE14158@mothafucka.localdomain>
 <4BCC829A.6000803@goop.org>
 <20100419182542.GI14158@mothafucka.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419182542.GI14158@mothafucka.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 03:25:43PM -0300, Glauber Costa wrote:
> On Mon, Apr 19, 2010 at 09:19:38AM -0700, Jeremy Fitzhardinge wrote:
> > On 04/19/2010 07:26 AM, Glauber Costa wrote:
> > >> Is the problem that the tscs are starting out of sync, or that they're
> > >> drifting relative to each other over time?  Do the problems become worse
> > >> the longer the uptime?  How large are the offsets we're talking about here?
> > >>     
> > > The offsets usually seem pretty small, under a microsecond. So I don't think
> > > it has anything to do with tscs starting out of sync. Specially because the
> > > delta-based calculation has the exact purpose of handling that case.
> > >   
> > 
> > So you think they're drifting out of sync from an initially synced
> > state?  If so, what would bound the drift?
> I think delta calculation introduces errors.

Yes.

> Marcelo can probably confirm it, but he has a nehalem with an appearently
> very good tsc source. Even this machine warps.
> 
> It stops warping if we only write pvclock data structure once and forget it,
> (which only updated tsc_timestamp once), according to him.

Yes. So its not as if the guest visible TSCs go out of sync (they don't
on this machine Glauber mentioned, or even on a multi-core Core 2 Duo),
but the delta calculation is very hard (if not impossible) to get right.

The timewarps i've seen were in the 0-200ns range, and very rare (once
every 10 minutes or so).

> Obviously, we can't do that everywhere.
