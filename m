Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab1HZEV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:21:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42641 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1HZEVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:21:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 13:13:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com
Subject: Re: [PATCH 2/6] cgroup: improve old cgroup handling in
 cgroup_attach_proc()
Message-Id: <20110826131359.096a8131.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1314312192-26885-3-git-send-email-tj@kernel.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
	<1314312192-26885-3-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 00:43:08 +0200
Tejun Heo <tj@kernel.org> wrote:

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
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

