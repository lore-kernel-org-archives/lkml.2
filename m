Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab2IFUir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:38:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795Ab2IFUio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:38:44 -0400
Date: Thu, 6 Sep 2012 13:38:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, lennart@poettering.net,
        kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120906203839.GM29092@google.com>
References: <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
 <1346837209.2600.14.camel@twins>
 <50471C0C.7050600@parallels.com>
 <1346840453.2461.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346840453.2461.6.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter, Glauber.

(I'm gonna write up cgroup core todos which should explain / address
this issue too.  ATM I'm a bit overwhelmed with stuff accumulated
while traveling.)

On Wed, Sep 05, 2012 at 12:20:53PM +0200, Peter Zijlstra wrote:
> But I don't really see the point though, this kind of interface would
> only ever work for the non-controlling and controlling controller
> combination (confused yet ;-), and I don't think we have many of those.

It's more than that.  One may not want to apply the same level of
granularity to different resources.  e.g. depending on the setup, IOs
may need to be further categorized and controlled than memory or vice
versa.

> I would really rather see a simplification of the entire cgroup
> interface space as opposed to making it more complex. And adding this
> subtree 'feature' only makes it more complex.

It does in the meantime but I think most of it can piggyback on the
existing css_set mechanism.  No matter what we do, this isn't gonna be
a short and easy transition.  More than half of the controllers don't
even support proper hierarchy yet.  We can't move to any kind of
unified hierarchy without getting that settled first.  I *think* I
have a plan which can mostly work now.  I'll write more later.

Thanks.

-- 
tejun
