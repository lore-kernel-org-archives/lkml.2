Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2JCW7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:59:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:59:39 -0400
Date: Thu, 4 Oct 2012 07:59:30 +0900
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20121003225930.GF19248@localhost>
References: <20120927142822.GG3429@suse.de>
 <20120927144942.GB4251@mtj.dyndns.org>
 <50646977.40300@parallels.com>
 <20120927174605.GA2713@localhost>
 <50649EAD.2050306@parallels.com>
 <20120930075700.GE10383@mtj.dyndns.org>
 <20120930080249.GF10383@mtj.dyndns.org>
 <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com>
 <20120930103732.GK10383@mtj.dyndns.org>
 <5069584A.8090809@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5069584A.8090809@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Mon, Oct 01, 2012 at 12:46:02PM +0400, Glauber Costa wrote:
> > Yeah, it will need some hooks.  For dentry and inode, I think it would
> > be pretty well isolated tho.  Wasn't it?
> 
> We would still need something for the stack. For open files, and for
> everything that becomes a potential problem. We then end up with 35
> different knobs instead of one. One of the perceived advantages of this
> approach, is that it condenses as much data as a single knob as
> possible, reducing complexity and over flexibility.

Oh, I didn't mean to use object-specific counting for all of them.
Most resources don't have such common misaccounting problem.  I mean,
for stack, it doesn't exist by definition (other than cgroup
migration).  There's no reason to use anything other than first-use
kmem based accounting for them.  My point was that for particularly
problematic ones like dentry/inode, it might be better to treat them
differently.

Thanks.

-- 
tejun
