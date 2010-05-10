Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0EJJmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:42:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0EJJmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:42:37 -0400
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
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
In-Reply-To: <1273483595.15998.56.camel@minggr.sh.intel.com>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 11:42:21 +0200
Message-ID: <1273484541.5605.3336.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:26 +0800, Lin Ming wrote:
> A new field "pmu_id" is added to struct perf_event_attr.
> 
> 2 new functions: perf_event_register_pmu, perf_event_lookup_pmu
> perf_event_register_pmu: the pmu registration facility
> perf_event_lookup_pmu: lookup the pmu via the passed in event->attr.pmu_id.
> 
> A new api pmu->init_event to replace hw_perf_event_init

Another problem, this patch breaks all of perf by removing the weak call
before there is a replacement.

Please rework such that there is a smooth transition.

Also, for compatibilities sake, the cpu pmu will be required to get
pmu_id==0, this doesn't provide that.

