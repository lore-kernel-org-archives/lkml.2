Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1HXAct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:32:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49560 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1HXAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:32:41 -0400
Date: Wed, 24 Aug 2011 02:32:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/6] cgroup: subsys->attach_task() should be called after
 migration
Message-ID: <20110824003234.GB23979@somewhere>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314138000-2049-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:19:55AM +0200, Tejun Heo wrote:
> cgroup_attach_task() calls subsys->attach_task() after
> cgroup_task_migrate(); however, cgroup_attach_proc() calls it before
> migration.  This actually affects some of the users.  Update
> cgroup_attach_proc() such that ->attach_task() is called after
> migration.

There have been a patch posted recently:

        "[PATCH][BUGFIX] cgroups: fix ordering of calls in cgroup_attach_proc"

that not only fixes that ordering but also only attach the task if the
migration happened correctly (task not exited).

Can somebody queue it for 3.2 ?
