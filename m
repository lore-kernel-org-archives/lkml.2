Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2IYKxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:53:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57088 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2IYKxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:53:00 -0400
Message-ID: <1348570364.3881.7.camel@twins>
Subject: Re: [PATCH 1/3] sched: Create sched_select_cpu() to give preferred
 CPU for power saving
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, tj@kernel.org, suresh.b.siddha@intel.com,
        venki@google.com, mingo@redhat.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Date: Tue, 25 Sep 2012 12:52:44 +0200
In-Reply-To: <cdec85a36f2da0d604aba8a330912ed3de2177b5.1348568074.git.viresh.kumar@linaro.org>
References: <viresh.kumar@linaro.org>
	 <cover.1348568074.git.viresh.kumar@linaro.org>
	 <cdec85a36f2da0d604aba8a330912ed3de2177b5.1348568074.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 16:06 +0530, Viresh Kumar wrote:
> +/* sched-domain levels */
> +#define SD_SIBLING             0x01    /* Only for CONFIG_SCHED_SMT */
> +#define SD_MC                  0x02    /* Only for CONFIG_SCHED_MC */
> +#define SD_BOOK                        0x04    /* Only for CONFIG_SCHED_BOOK */
> +#define SD_CPU                 0x08    /* Always enabled */
> +#define SD_NUMA                        0x10    /* Only for CONFIG_NUMA */ 

Urgh, no, not more of that nonsense.. I want to get rid of that
hardcoded stuff, not add more of it.
