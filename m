Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1CYVE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:04:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab1CYVEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:04:25 -0400
Subject: Re: [RFC][PATCH 09/14] sched: Dynamically allocate
 sched_domain/sched_group data-structures
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <AANLkTikUGwkOwUoGcti0SOFWVKxAMZNUk9c30oBRFmMx@mail.gmail.com>
References: <20110314150613.749843433@chello.nl>
	 <20110314152227.191956337@chello.nl>
	 <AANLkTikUGwkOwUoGcti0SOFWVKxAMZNUk9c30oBRFmMx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 22:06:23 +0100
Message-ID: <1301087183.2250.306.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 18:23 -0700, Venkatesh Pallipadi wrote:
> >        if (affine_sd) {
> > -               if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> > -                       return select_idle_sibling(p, cpu);
> > -               else
> > -                       return select_idle_sibling(p, prev_cpu);
> > +               if (wake_affine(affine_sd, p, sync))
> > +                       prev_cpu = cpu;
> > +
> > +               new_cpu = select_idle_sibling(p, prev_cpu);
> > +               goto unlock;
> >        }
> >
> >        while (sd) {
> 
> This would result in going through wake_affine() doing all
> effective_load stuff even with cpu == prev_cpu. No?
> So, we need either if (cpu != prev_cpu && wake_affine(affine_sd, p,
> sync)) or an check at the start to have want_affine=0 for this case.

D'0h yeah, I missed the conditional execution of wake_affine there, silly me.

