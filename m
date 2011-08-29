Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab1H2QAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:00:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab1H2QAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:00:06 -0400
Date: Mon, 29 Aug 2011 17:56:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 14/16] freezer: make freezing() test freeze conditions
	in effect instead of TIF_FREEZE
Message-ID: <20110829155640.GA8392@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-15-git-send-email-tj@kernel.org> <20110829154944.GA7531@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829154944.GA7531@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid I wasn't clear....

On 08/29, Oleg Nesterov wrote:
>
> On 08/19, Tejun Heo wrote:
> >
> > @@ -311,9 +315,11 @@ static int freezer_change_state(struct cgroup *cgroup,
> >
> >  	switch (goal_state) {
> >  	case CGROUP_THAWED:
> > +		atomic_dec(&system_freezing_cnt);
> >  		unfreeze_cgroup(cgroup, freezer);
> >  		break;
> >  	case CGROUP_FROZEN:
> > +		atomic_inc(&system_freezing_cnt);
>
> This is harmless, but afaics is not exactly right. CGROUP_FROZEN doesn't
> need system_freezing_cnt != 0, everything is already frozen and we just
> provoke freezing_slow_path() without any reason. Right?

Of course, this atomic_inc() is right, we are going to call
try_to_freeze_cgroup(). But probably it makes sense to do atomic_dec()
when freezer->state becomes CGROUP_FROZEN.

Oleg.

