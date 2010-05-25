Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab0EYQ6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:58:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0EYQ6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:58:02 -0400
Date: Tue, 25 May 2010 19:53:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Sridhar Samudrala <samudrala.sridhar@gmail.com>,
       netdev <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 1/3] cgroups: Add an API to attach a task to current
	task's cgroup
Message-ID: <20100525165334.GA27307@redhat.com>
References: <1274227488.2370.107.camel@w-sridhar.beaverton.ibm.com> <AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinsrFoLVKDFM5pcKcL_6MvAzhR6IzbNmWKh3BDh@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 03:22:15PM -0700, Paul Menage wrote:
> On Tue, May 18, 2010 at 5:04 PM, Sridhar Samudrala
> <samudrala.sridhar@gmail.com> wrote:
> > Add a new kernel API to attach a task to current task's cgroup
> > in all the active hierarchies.
> >
> > Signed-off-by: Sridhar Samudrala <sri@us.ibm.com>
> 
> Reviewed-by: Paul Menage <menage@google.com>
> 
> It would be more efficient to just attach directly to current->cgroups
> rather than potentially creating/destroying one css_set for each
> hierarchy until we've completely converged on current->cgroups - but
> that would require a bunch of refactoring of the guts of
> cgroup_attach_task() to ensure that the right can_attach()/attach()
> callbacks are made. That doesn't really seem worthwhile right now for
> the initial use, that I imagine isn't going to be
> performance-sensitive.
> 
> Paul

Is this patch suitable for 2.6.35?
It is needed to fix the case where vhost user might cause a kernel thread
to consume more CPU than allowed by the cgroup.
Should I just merge it through the vhost tree?
Ack for this?

Thanks,

-- 
MST
