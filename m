Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab0JAL7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:49324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab0JAL7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:35 -0400
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group
 change
From: Peter Zijlstra <peterz@infradead.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <AANLkTikVQist_VnCcpZzU78t0TVuocwOcDPG4POVzSdv@mail.gmail.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	 <1285843669.2144.2.camel@laptop>
	 <AANLkTikVQist_VnCcpZzU78t0TVuocwOcDPG4POVzSdv@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Oct 2010 13:59:28 +0200
Message-ID: <1285934368.2144.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 12:14 -0700, Dima Zavin wrote:
> 
> > Please explain this stuff..
> 
> The situation today is quite bad for sleeping tasks. Currently, when
> you move a sleeping thread between cgroups, the thread can retain its
> old vruntime value if the old group was far ahead of the new group
> since it essentially does a max(se->vruntime, new_vruntime) in
> place_entity. This can prevent the task from running for a very long
> time. That is what this patch was trying to address. It normalizes the
> sleeper thread's vruntime before moving it to the new group.
> 
> 

Hrm,.. ok, I tend to not use this cgroup gunk more that I absolutely
have to, so I'll take your word for it.

But doesn't normal cross-cpu task migration already solve this problem?
Therefore wouldn't it be possible to adapt/extend that code to also deal
with this particular issue?

It would avoid growing more cgroup fudge..
