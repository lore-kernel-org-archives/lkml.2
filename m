Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2IEJHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:07:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2IEJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:07:49 -0400
Date: Wed, 5 Sep 2012 02:07:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl,
        pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905090744.GG3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471379.3060603@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50471379.3060603@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Sep 05, 2012 at 12:55:21PM +0400, Glauber Costa wrote:
> > So, I think it's desirable for all controllers to be able to handle
> > hierarchies the same way and to have the ability to tag something as
> > belonging to certain group in the hierarchy for all controllers but I
> > don't think it's desirable or feasible to require all of them to
> > follow exactly the same grouping at all levels.
> 
> By "different levels of granularity" do you mean having just a subset of
> them turned on at a particular place?

Heh, this is tricky to describe and I'm not really following what you
mean.  They're all on the same tree but a controller should be able to
handle a given subtree as single group.  e.g. if you draw the tree,
different controllers should be able to draw different enclosing
circles and operate on the simplifed tree.  How flexible that should
be, I don't know.  Maybe it would be enough to be able to say "treat
all children of this node as belonging to this node for controllers X
and Y".

> If yes, having them guaranteed to be comounted is still perceived by me
> as a good first step. A natural following would be to turn them on/off
> on a per-group basis.

I don't agree with that.  If we do it that way, we would lose
differing granularity from forcing co-mounting and then restore it
later when the subtree handling is implemented.  If we can do away
with differing granularity, that's fine; otherwise, it doesn't make
much sense to remove and then restore it.

Thanks.

-- 
tejun
