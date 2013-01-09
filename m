Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab3AIVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:17:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3AIVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:17:06 -0500
Date: Wed, 9 Jan 2013 13:17:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Message-Id: <20130109131705.4156ba5c.akpm@linux-foundation.org>
In-Reply-To: <50EDDCAA.6070004@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-12-git-send-email-glommer@parallels.com>
	<20130109124220.ad9f1a54.akpm@linux-foundation.org>
	<50EDDCAA.6070004@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 01:10:02 +0400
Glauber Costa <glommer@parallels.com> wrote:

> The main advantage I see in this approach, is that there is way less
> data to be written using a header. Although your way works, it means we
> will write the strings "nice", "system", etc. #cpu times. Quite a waste.

Yes, overhead can be a significant issue with this type of interface. 
But we already incurred a massive overhead by using a human-readable
ascii interface.  If performance is an issue, perhaps the whole thing
should be grafted onto taskstats instead.  Or create a new
taskstats-like thing.

btw, a more typical interface would be

cat /.../cpu0
nice:nn
system:nn
irq:nn

- the traditional one-per-line name:value tuples.  But I'd assumed that
having a file per CPU would be aawkward.
