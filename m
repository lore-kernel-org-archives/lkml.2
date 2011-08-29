Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab1H2Gai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:30:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60347 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1H2Gac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:30:32 -0400
Date: Mon, 29 Aug 2011 08:30:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 13/16] cgroup_freezer: prepare for removal of TIF_FREEZE
Message-ID: <20110829063026.GA16431@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-14-git-send-email-tj@kernel.org>
 <20110828173954.GA26588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828173954.GA26588@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 28, 2011 at 07:39:54PM +0200, Oleg Nesterov wrote:
> > @@ -321,6 +307,8 @@ static int freezer_change_state(struct cgroup *cgroup,
> >  	if (goal_state == freezer->state)
> >  		goto out;
> >
> > +	freezer->state = goal_state;
> > +
> 
> This doesn't look right at all... Unless I misssed something.
> 
> A user writes "FROZEN" into the control file, our goal is CGROUP_FROZEN.
> 
> But. freezer_change_state() should set CGROUP_FREEZING, not CGROUP_FROZEN.
> This cgrp is not frozen yet, _FROZEN should be set by update_if_frozen(),
> assuming that the user reads the state waiting until the operation
> completes.

Oops, right.  That should have been CGROUP_FREEZING.  Will fix.

Thanks.

-- 
tejun
