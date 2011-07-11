Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1GKBWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 21:22:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab1GKBWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 21:22:39 -0400
Date: Mon, 11 Jul 2011 09:22:07 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110711012207.GB2135@localhost.localdomain>
References: <20110707053036.173186930@google.com>
MIME-Version: 1.0
In-Reply-To: <20110707053036.173186930@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-11 09:21:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-11 09:21:52,
	Serialize complete at 2011-07-11 09:21:52
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:30:36PM -0700, Paul Turner wrote:
> Hi all,
> 
> Please find attached an incremental revision on v7 of bandwidth control.
> 
> The only real functional change is an improvement to update shares only as we
> leave a throttled state.  The remainder is largely refactoring, expansion of
> comments, and code clean-up.
> 
> Hidetoshi Seto and Hu Tao have been kind enough to run performance benchmarks
> against v7 measuring the scheduling path overheads versus pipe-test-100k.
> Results can be found at:
> 
> https://lkml.org/lkml/2011/6/24/10
> https://lkml.org/lkml/2011/7/4/347
> 
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

Hi Paul,

I'm sorry these data are got by a config with some debug options on.
I've re-tested with a fine config, see

https://lkml.org/lkml/2011/7/6/516

-- 
Thanks,
Hu Tao
