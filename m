Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab0F3SLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:11:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58418 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab0F3SLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:11:39 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <4C2B7C9F.5070100@linux.vnet.ibm.com>
References: <20100624142804.431553874@chello.nl>
	 <4C262949.3030804@linux.vnet.ibm.com> <1277738009.3561.129.camel@laptop>
	 <4C2B7C9F.5070100@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 20:11:28 +0200
Message-ID: <1277921488.1868.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 10:19 -0700, Corey Ashford wrote:
> However, there still are concerns relative to writing these control 
> registers from an interrupt handler because of the latency that will be 
> incurred, however slow we choose to do the event rotation.  So at least 
> for the Wire-Speed processor, we may need a worker thread of some sort 
> to hand off the work to. 

Right, once we have per-pmu contexts we can look at having means to
over-ride the means of rotation, such that the pmu can optionally drive
it itself instead of through the common tick.
