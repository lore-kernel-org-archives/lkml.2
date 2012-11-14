Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2KNIUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:20:12 -0500
Received: from mx2.parallels.com ([64.131.90.16]:38076 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2KNIUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:20:10 -0500
Message-ID: <50A3C4C5.10004@parallels.com>
Date: Wed, 14 Nov 2012 17:20:21 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()
References: <20121113202714.GA21185@mtj.dyndns.org> <20121113202745.GB21185@mtj.dyndns.org>
In-Reply-To: <20121113202745.GB21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:27 PM, Tejun Heo wrote:
> From bbf2566f9f4fc79ff3320e83cafb69533efc9ea0 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 13 Nov 2012 12:21:50 -0800
> 
> Currently CGRP_CPUSET_CLONE_CHILDREN triggers ->post_clone().  Now
> that clone_children is cpuset specific, there's no reason to have this
> rather odd option activation mechanism in cgroup core.  cpuset can
> check the flag from its ->css_allocate() and take the necessary
> action.
> 
> Move cpuset_post_clone() logic to the end of cpuset_css_alloc() and
> remove cgroup_subsys->post_clone().
> 
> Loosely based on Glauber's "generalize post_clone into post_create"
> patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Original-patch-by: Glauber Costa <glommer@parallels.com>
> Original-patch: <1351686554-22592-2-git-send-email-glommer@parallels.com>
> Cc: Glauber Costa <glommer@parallels.com>

I don't have any preference one way or the other. This patch seems to do
the job.



