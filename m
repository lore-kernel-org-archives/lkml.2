Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2FOSni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:43:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57824 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab2FOSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:43:37 -0400
Date: Fri, 15 Jun 2012 20:43:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore support
Message-ID: <20120615184331.GL11413@one.firstfloor.org>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com> <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com> <1339774107.2559.73.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339774107.2559.73.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 05:28:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> > @@ -808,6 +994,14 @@ static int __init uncore_cpu_init(void)
> >         int ret, cpu;
> >  
> >         switch (boot_cpu_data.x86_model) {
> > +       case 26: /* Nehalem */
> > +       case 30:
> > +       case 37: /* Westmere */
> > +               msr_uncores = nhm_msr_uncores;
> > +               break;
> > +       case 42: /* Sandy Bridge */
> > +               msr_uncores = snb_msr_uncores;
> > +               break; 
> 
> What about WSP-EP (44)? Does it have an uncore similar to the regular
> WSM (37) or WSM-EX / Xeon-E7 (47) ?
> 
> NHM-EX and WSM-EX are similar again, and not (yet) supported by these
> patches, right?

(NHM,WSM)-EX uncores are completely different from EP and need a new driver.

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
