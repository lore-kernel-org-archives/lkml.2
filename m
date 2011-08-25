Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1HYJdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:33:22 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:65465 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HYJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <1314138000-2049-4-git-send-email-tj@kernel.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org> <1314138000-2049-4-git-send-email-tj@kernel.org>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 25 Aug 2011 02:32:59 -0700
X-Google-Sender-Auth: 8CfD7Q5mORK59sKu13lXasYpXSA
Message-ID: <CALdu-PAPO7L0yW1ZfZUPuPLjVmW_euO24P-gd3tCY5zFq0FD2g@mail.gmail.com>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 3:19 PM, Tejun Heo <tj@kernel.org> wrote:
> +Called prior to moving one or more tasks into a cgroup; if the
> +subsystem returns an error, this will abort the attach operation.
> +@tset contains the tasks to be attached and is guaranteed to have at
> +least one task in it. If there are multiple, it's guaranteed that all
> +are from the same thread group, @tset contains all tasks from the
> +group whether they're actually switching cgroup or not, and the first
> +task is the leader.

I'd reformat this a bit for clarity:

If there are multiple tasks in the taskset, then:
  - it's guaranteed that all are from the same thread group
  - @tset contains all tasks from the thread group whether or not
they're switching cgroup
  - the first task is the leader

Acked-by: Paul Menage <paul@paulmenage.org>
