Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1H1Rnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 13:43:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1H1Rn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:43:26 -0400
Date: Sun, 28 Aug 2011 19:39:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 13/16] cgroup_freezer: prepare for removal of TIF_FREEZE
Message-ID: <20110828173954.GA26588@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-14-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-14-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun.

Well, yet another sorry for delay ;)

On 08/19, Tejun Heo wrote:
>
> @@ -279,7 +268,6 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
>  	struct task_struct *task;
>  	unsigned int num_cant_freeze_now = 0;
>
> -	freezer->state = CGROUP_FREEZING;

...

> @@ -321,6 +307,8 @@ static int freezer_change_state(struct cgroup *cgroup,
>  	if (goal_state == freezer->state)
>  		goto out;
>
> +	freezer->state = goal_state;
> +

This doesn't look right at all... Unless I misssed something.

A user writes "FROZEN" into the control file, our goal is CGROUP_FROZEN.

But. freezer_change_state() should set CGROUP_FREEZING, not CGROUP_FROZEN.
This cgrp is not frozen yet, _FROZEN should be set by update_if_frozen(),
assuming that the user reads the state waiting until the operation
completes.

Oleg.

