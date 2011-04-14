Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab1DNIol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:44:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59107 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753324Ab1DNIoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:44:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qHNJ0GFCqWLcWry9Ibtv5+DHsUbI6I8g5p15jes
	/DUuUacgd+jEiE
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
From: Mike Galbraith <efault@gmx.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1302770084.27576.13.camel@marge.simson.net>
References: <1302170153.12304.31.camel@marge.simson.net>
	 <4DA50430.8020701@cn.fujitsu.com>
	 <1302664313.7407.29.camel@marge.simson.net>
	 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
	 <1302713819.7448.22.camel@marge.simson.net>
	 <1302765999.8042.8.camel@marge.simson.net>
	 <1302770084.27576.13.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 10:44:35 +0200
Message-ID: <1302770675.7529.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 10:34 +0200, Mike Galbraith wrote:
> > > On Wed, 2011-04-13 at 15:16 +0200, Paul Menage wrote:
> 
> > > > > +       kfree(cgrp);
> > > > 
> > > > We might want to punt this through RCU again, in case the subsystem
> > > > destroy() callbacks left anything around that was previously depending
> > > > on the RCU barrier.
> 
> Yup, great idea.  Two stage teardown/free quenched the fireworks

Correction:  made fireworks take longer to ignite.   Roughly a minute
after I poked xmit, box exploded.  Hohum.  BTTODB

	-Mike


