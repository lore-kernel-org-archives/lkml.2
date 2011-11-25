Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1KYCia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:38:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35280 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1KYCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:38:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Nov 2011 11:37:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com, pjt@google.com,
        cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 4/4] cpuacct.stat: re-use scheduler statistics for the
 root cgroup
Message-Id: <20111125113720.e57a7cc9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322184806-20421-5-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
	<1322184806-20421-5-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 23:33:26 -0200
Glauber Costa <glommer@parallels.com> wrote:

> Right now, after we collect tick statistics for user and system and store them
> in a well known location, we keep the same statistics again for cpuacct.
> Since cpuacct is hierarchical, the numbers for the root cgroup should be
> absolutely equal to the system-wide numbers.
> 
> So it would be better to just use it: this patch changes cpuacct accounting
> in a way that the cpustat statistics are kept in a struct kernel_cpustat percpu
> array. In the root cgroup case, we just point it to the main array. The rest of
> the hierarchy walk can be totally disabled later with a static branch - but I am
> not doing it here.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Paul Tuner <pjt@google.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>

seems reasonable to me.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


