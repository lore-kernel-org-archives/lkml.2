Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0EJKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:18:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:58134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0EJKS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="620320003"
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273484430.5605.3334.camel@twins>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
	 <1273484430.5605.3334.camel@twins>
Content-Type: text/plain
Date: Mon, 10 May 2010 18:17:50 +0800
Message-Id: <1273486670.15998.80.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:40 +0800, Peter Zijlstra wrote:
> On Mon, 2010-05-10 at 17:26 +0800, Lin Ming wrote:
> > +static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
> > +{
> > +       struct pmu *pmu;
> > +       int pmu_id = event->attr.pmu_id;
> > +
> > +       list_for_each_entry(pmu, &pmus, entry) {
> > +               if (pmu->id == pmu_id)
> > +                       return pmu;
> > +       }
> > +
> > +       return NULL;
> > +}
> 
> > +void perf_event_register_pmu(struct pmu *pmu)
> > +{
> > +       pmu->id = pmu_id_curr++;
> > +       list_add_tail(&pmu->entry, &pmus);
> > +} 
> 
> That will be wanting some sort of synchronization

Will add a mutex to protect the list of pmus.

