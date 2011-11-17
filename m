Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1KQQNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:13:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab1KQQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:13:21 -0500
Date: Thu, 17 Nov 2011 17:13:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111117161318.GA1233@tiehlicka.suse.cz>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <4EC4DE9D.3040703@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC4DE9D.3040703@inria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 17-11-11 11:14:53, Tomasz Buchert wrote:
> Hi,
> I'm trying to understand now why I did that change in
> 
> 2d3cbf8bc (the bug itself was in the if-the-else clause in
> update_if_frozen , anyway).
> Well, when I look at this now I think that there is nothing wrong
> with your patch.
> You can try my testcases from 2d3cbf8bc and 0bdba580, but it should be ok.

Yes, I have tried it before sending the patch.

> One thing I am not sure completely of is the following situation. So
> the group is frozen
> with the STOPPED task inside. There are few questions:
> * if you send SIGCONT to the task now, will it wake up?

No, it will enter refrigerator and wake up on thawing the group. Check
out `goto relock' after do_signal_stop returns.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
