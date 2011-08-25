Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1HYJMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:12:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40554 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1HYJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:12:33 -0400
Date: Thu, 25 Aug 2011 11:12:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/6] cgroup: don't use subsys->can_attach_task() or
 ->attach_task()
Message-ID: <20110825091228.GF3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-5-git-send-email-tj@kernel.org>
 <CALdu-PCc2RzedXubReF9huamL6W+5qGCfXNNvqS2yUk3QTHRng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PCc2RzedXubReF9huamL6W+5qGCfXNNvqS2yUk3QTHRng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Thu, Aug 25, 2011 at 02:07:35AM -0700, Paul Menage wrote:
> Doesn't the other part of this patch set, that avoids calling the
> *attach() methods for tasks that aren't moving, eliminate the need for
> the usage of skip_cgrp here (and elsewhere)? When do we actually need
> to pass a non-NULL skip_cgrp to cgroup_taskset_for_each()?

If any task is moving ->*attach() should be called.  Whether the @tset
passed in should contain tasks which aren't changing cgroups is
debatable.  The operation is guaranteed to be for an entire thread
group and it makes sense to make at least the leader always available
even if it's not moving.  Given that the operation is defined to be
per-thread-group, I think it's better to pass in the whole thread
group with an easy way to skip the ones which aren't moving.  For
example, memcg seems to need to find the mm->owner and it's possible
that the mm->owner might not be changing cgroups.

Thanks.

-- 
tejun
