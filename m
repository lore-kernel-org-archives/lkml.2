Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100Ab1D1Pbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:31:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1D1Pbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:31:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] sparc: convert old cpumask API into new one
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
In-Reply-To: <BANLkTimdWkLF3FLOd6CUTKQ_+Fhhor9VJA@mail.gmail.com>
References: <20110429001547.3D6C.A69D9226@jp.fujitsu.com> <BANLkTimdWkLF3FLOd6CUTKQ_+Fhhor9VJA@mail.gmail.com>
Message-Id: <20110429003328.3D7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:31:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 28, 2011 at 12:14 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Adapt new API. Almost change is trivial, most important change are to
> > remove following like =operator.
> >
> >  cpumask_t cpu_mask = *mm_cpumask(mm);
> 
> Could you note that you are changing this to:
> 
> cpumask_t cpu_mask;
> cpumask_copy(&cpu_mask, mm_cpumask(mm));
> 
> >  cpus_allowed = current->cpus_allowed;
> 
> And this to:
> 
> cpumask_copy(&cpus_allowed, tsk_cpus_allowed(current));

The code explain it clearly?


> > diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
> > index 5c14968..3bb2eac 100644
> > --- a/arch/sparc/kernel/of_device_64.c
> > +++ b/arch/sparc/kernel/of_device_64.c
> > @@ -622,8 +622,9 @@ static unsigned int __init build_one_device_irq(struct platform_device *op,
> >  out:
> >        nid = of_node_to_nid(dp);
> >        if (nid != -1) {
> > -               cpumask_t numa_mask = *cpumask_of_node(nid);
> > +               cpumask_t numa_mask;
> >
> please, could you remove the extra blank line?
> 
> > +               cpumask_copy(&numa_mask, cpumask_of_node(nid));
> >                irq_set_affinity(irq, &numa_mask);

Why? one blank line between declaration and statement is standard coding style.



