Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0CYMTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:19:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0CYMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:19:22 -0400
Subject: Re: [RFC,PATCH 2/2] cputimers/proc:
 do_task_stat()->thread_group_times() is racy and O(n) under ->siglock
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100325121250.GA3664@redhat.com>
References: <20100324204554.GA31780@redhat.com>
	 <1269464082.12097.3.camel@laptop>  <20100325121250.GA3664@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 13:19:17 +0100
Message-ID: <1269519557.12097.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 13:12 +0100, Oleg Nesterov wrote:
> > Right, so from what I remember the issue is that, yes top et al rely on
> > that monotonicity,
> 
> Really?  So, do you think the change above will break user-space?
> 
> How sad :/ 

IIRC top can give very funny results if you break it hard enough, it
likes to give 9999% cputime if the thing goes backwards over the sample
interval.

But I'm not sure your race is large enough to ever show up like that, so
it might all just work out, but in general it does tend to require
monotonic times.

