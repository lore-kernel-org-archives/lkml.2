Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1GGLXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:23:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1GGLXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:23:21 -0400
Date: Thu, 7 Jul 2011 13:23:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110707112302.GB8227@elte.hu>
References: <20110707053036.173186930@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707053036.173186930@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Turner <pjt@google.com> wrote:

> The summary results (from Hu Tao's most recent run) are:
>                                             cycles                   instructions            branches
> -------------------------------------------------------------------------------------------------------------------
> base                                        7,526,317,497           8,666,579,347            1,771,078,445
> +patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%)
> +patch, 10000000000/1000(quota/period)      7,856,873,327 (4.39%)   8,822,227,540 (1.80%)    1,801,766,182 (1.73%)
> +patch, 10000000000/10000(quota/period)     7,797,711,600 (3.61%)   8,754,747,746 (1.02%)    1,788,316,969 (0.97%)
> +patch, 10000000000/100000(quota/period)    7,777,784,384 (3.34%)   8,744,979,688 (0.90%)    1,786,319,566 (0.86%)
> +patch, 10000000000/1000000(quota/period)   7,802,382,802 (3.67%)   8,755,638,235 (1.03%)    1,788,601,070 (0.99%)
> ------------------------------------------------------------------------------------------------------------------

Well, the most recent run Hu Tao sent (with lockdep disabled) are 
different:

 table 2. shows the differences between patch and no-patch. quota is set
          to a large value to avoid processes being throttled.

        quota/period          cycles                   instructions             branches
--------------------------------------------------------------------------------------------------
base                          1,146,384,132           1,151,216,688            212,431,532
patch   cgroup disabled       1,163,717,547 (1.51%)   1,165,238,015 ( 1.22%)   215,092,327 ( 1.25%)
patch   10000000000/1000      1,244,889,136 (8.59%)   1,299,128,502 (12.85%)   243,162,542 (14.47%)
patch   10000000000/10000     1,253,305,706 (9.33%)   1,299,167,897 (12.85%)   243,175,027 (14.47%)
patch   10000000000/100000    1,252,374,134 (9.25%)   1,299,314,357 (12.86%)   243,203,923 (14.49%)
patch   10000000000/1000000   1,254,165,824 (9.40%)   1,299,751,347 (12.90%)   243,288,600 (14.53%)
--------------------------------------------------------------------------------------------------


The +1.5% increase in vanilla kernel context switching performance is 
unfortunate - where does that overhead come from?

The +9% increase in cgroups context-switching overhead looks rather 
brutal.

Thanks,

	Ingo
