Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1KUXHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:07:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64555 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1KUXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:07:14 -0500
Date: Mon, 21 Nov 2011 15:07:09 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111121230709.GR25776@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 16, 2011 at 10:50:34PM +0100, Michal Hocko wrote:
> +/* Task is frozen or will freeze immediately when next it gets woken */
> +static bool is_task_frozen_enough(struct task_struct *task)
> +{
> +	return frozen(task) ||
> +		(task_is_stopped_or_traced(task) && freezing(task));
> +}

Hmmm... w/ pending freezer updates, the above would always return
%true if there's freezing in progress, which can't be right.  Maybe
just test stopped/traced?

  http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/pm-freezer

Thanks.

-- 
tejun
