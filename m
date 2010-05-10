Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0EJJnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:43:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0EJJnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:43:31 -0400
Subject: Re: [RFC][PATCH 9/9] perf top: set perf_event_attr->pmu_id
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
In-Reply-To: <1273483760.15998.63.camel@minggr.sh.intel.com>
References: <1273483760.15998.63.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 May 2010 11:43:11 +0200
Message-ID: <1273484591.5605.3337.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 17:29 +0800, Lin Ming wrote:
> This is just a temporary patch to show the setting of
> perf_event_attr->pmu_id. 
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/builtin-top.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index ed9b5b6..f775393 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1213,6 +1213,11 @@ static void start_counter(int i, int counter)
>  
>  	attr = attrs + counter;
>  
> +	/*
> +	 * TBD: in the future, may read /sys/devices/system/cpu/pmus/<pmu_id> 
> +	 * to get the pmu id
> +	 */
> +	attr.pmu_id = 0;

No, cpu PMUs must always be pmu_id 0.
