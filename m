Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0I3KsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:48:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:38455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab0I3Kr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:47:58 -0400
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group
 change
From: Peter Zijlstra <peterz@infradead.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1285742774-5013-1-git-send-email-dima@android.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 12:47:49 +0200
Message-ID: <1285843669.2144.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 23:46 -0700, Dima Zavin wrote:
> This adds a new callback, prep_move_task, to struct sched_class
> to give sched_fair the opportunity to adjust the task's vruntime
> just before setting its new group.
> 
> This allows us to properly normalize a sleeping task's vruntime
> when moving it between different cgroups.

Don't much like these patches, and changelogs need full descriptions not
fuzzy links out to the interwebs that might or might not stay valid.

If you change a task's cgroup, the task is new in that cgroup and should
be placed like a new task would, carrying over any history it has in the
old cgroup is dubious at best.

Please explain this stuff..
