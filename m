Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1KNUh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:37:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58026 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1KNUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:37:58 -0500
Date: Mon, 14 Nov 2011 21:37:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 06/10] cgroup: improve old cgroup handling in
 cgroup_attach_proc()
Message-ID: <20111114203744.GH9446@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320191193-8110-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:46:29PM -0700, Tejun Heo wrote:
> cgroup_attach_proc() behaves differently from cgroup_attach_task() in
> the following aspects.
> 
> * All hooks are invoked even if no task is actually being moved.
> 
> * ->can_attach_task() is called for all tasks in the group whether the
>   new cgrp is different from the current cgrp or not; however,
>   ->attach_task() is skipped if new equals new.  This makes the calls
>   asymmetric.
> 
> This patch improves old cgroup handling in cgroup_attach_proc() by
> looking up the current cgroup at the head, recording it in the flex
> array along with the task itself, and using it to remove the above two
> differences.  This will also ease further changes.
> 
> -v2: nr_todo renamed to nr_migrating_tasks as per Paul Menage's
>      suggestion.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
