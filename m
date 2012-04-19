Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab2DSUGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:06:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30448 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2DSUG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:06:29 -0400
Date: Thu, 19 Apr 2012 16:00:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
        Marcus Granado <marcus.granado@citrix.com>, xen-devel@lists.xen.org,
        Ben Guthro <ben@guthro.net>
Subject: Re: [Xen-devel] [PATCH 2/2] xen: implement IRQ_WORK_VECTOR handler
Message-ID: <20120419200023.GD28211@phenom.dumpdata.com>
References: <1334470172-3861-1-git-send-email-mlin@ss.pku.edu.cn>
 <1334470172-3861-3-git-send-email-mlin@ss.pku.edu.cn>
 <20120416203210.GD14982@phenom.dumpdata.com>
 <CAF1ivSZ8H2jp6sv=F8DXBAG9Wi87zCLh5Lbh+aeN66eJg_F1_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF1ivSZ8H2jp6sv=F8DXBAG9Wi87zCLh5Lbh+aeN66eJg_F1_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F90700A.0100,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id)
> >> +{
> >> +     irq_enter();
> >> +     inc_irq_stat(apic_irq_work_irqs);
> >> +     irq_work_run();
> >
> > I think this usually done the other way around:
> >
> > irq_work_run()
> > inc_irq_stat(apic_irq_work_irqs)
> >
> > Or is there an excellent reason for doing it this way?
> 
> Copy & paste from smp_irq_work_interrupt().
> But I think there is no much difference.
> 
> Anyway, I can change it if needed.

Please do. It looks at odds with the other usages in this file.
