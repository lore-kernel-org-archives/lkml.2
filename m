Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab2KGVIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:08:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35912 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2KGVH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:07:58 -0500
Date: Wed, 7 Nov 2012 15:07:53 -0600
From: Nishanth Menon <nm@ti.com>
To: <jemele@acm.org>
CC: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-omap@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] cpufreq: OMAP: if an iva clock name is specified,
 load iva resources
Message-ID: <20121107210753.GA23274@kahuna>
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
 <1352252861-18384-2-git-send-email-jemele@gmail.com>
 <20121107145352.GA15742@kahuna>
 <CALH_86ST1kF_csak_75Dk7dDupOqdCT=H11MKBeLsiyqi5vd_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALH_86ST1kF_csak_75Dk7dDupOqdCT=H11MKBeLsiyqi5vd_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:16-20121107, Joshua Emele wrote:
> On Wed, Nov 7, 2012 at 6:53 AM, Nishanth Menon <nm@ti.com> wrote:
> 
> > On 17:47-20121106, Joshua Emele wrote:
> > > +static int __cpuinit omap_iva_init(struct cpufreq_policy *policy)
> > > +{
> > > +     int result;
> > > +     if (!iva_clk_name) {
> > > +             pr_info("%s: iva unavailable\n", __func__);
> > > +             return 0;
> > > +     }
> > > +     iva_dev = omap_device_get_by_hwmod_name("iva");
> >
> > NAK. Reasons as follows:
> > a) cpufreq is purely meant for cpu, not IVA. we should instead be using
> > devfreq which is designed around the usage for co-processor
> > b) clubbing ARM's frequency decision is definitely NOT equal to IVA
> > frequency decision, not only is it wrong in terms of modularization, it
> > is wrong in terms of power benefits as well (not to mention weirdness
> > needed when you look at all OMAP SoC variants)
> > c) DVFS is not trivial around multiple co-processor transitions -> core
> > OPPs (as dependent OPP) needs to be addressed as well. ideally common
> > clock framework could take care of clock dependencies.
> It looks like you've done some work on an omap devfreq coprocessor driver (
> http://pastebin.pandaboard.org/index.php/view/85100576). Are there any
> plans to merge this driver?
It is an sample driver about how it could be done - this was not in any
form meant for merge. there are few angles to it:
a) ability for coprocessors to provide load and idle information back to
master processor
b) integrating it into regular existing framework.

Yes, the need is definitely identified, there are many different
solutions floating around in TI kernel forks, devfreq at the moment
seems to be the rationale choice in terms of a solution that is aligned
with community needs, so we are slowly building towards it.

Any contributions towards that is very appreciated ofcourse :). the
quick reference to latest code meant for 3.8 rc1 target could be found
here:
http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=summary

-- 
Regards,
Nishanth Menon
