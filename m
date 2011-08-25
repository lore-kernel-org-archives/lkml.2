Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HYJUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:20:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44165 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1HYJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:20:50 -0400
Date: Thu, 25 Aug 2011 11:20:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
Message-ID: <20110825092045.GG3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-4-git-send-email-tj@kernel.org>
 <CALdu-PDAgqeRJt5vqTB9wddwz70Yn+Jf-Pb0dDKDBD_q37tHQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PDAgqeRJt5vqTB9wddwz70Yn+Jf-Pb0dDKDBD_q37tHQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 02:14:12AM -0700, Paul Menage wrote:
> The general idea of passing consistent information to all *attach
> methods seems good, but isn't it simpler to just fix up the various
> method signatures?

I think having separate ->attach() and ->attach_task() is inherently
broken.  Look at the memcg discussion I had in this thread for
reference and as soon as we need to do something across the tasks
being migrated, iteration-by-callback becomes very painful.
e.g. let's say memcg wants to find the mm->owner and wants to print
warning or fail if that doesn't work out.  How would that be
implemented if it's iterating by callback.

> The whole point of having *attach() and *attach_task() was to minimize
> the amount of boilerplate (in this case, iterating across a new
> cgroup_taskset abstraction) in the subsystems, leaving that to the
> cgroups framework.

Yeah, I agree with making things easier for subsystems but I violently
disagree that iteration-by-callback is helpful in any way.  If
control-loop style iterator is at all possible, it's almost always
better to go that way.

Thanks.

-- 
tejun
