Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1GGL3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:29:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41718 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1GGL3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:29:13 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <20110707112302.GB8227@elte.hu>
References: <20110707053036.173186930@google.com>
	 <20110707112302.GB8227@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 13:28:21 +0200
Message-ID: <1310038101.3282.557.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 13:23 +0200, Ingo Molnar wrote:

> Well, the most recent run Hu Tao sent (with lockdep disabled) are 
> different:
> 
>  table 2. shows the differences between patch and no-patch. quota is set
>           to a large value to avoid processes being throttled.
> 
>         quota/period          cycles                   instructions             branches
> --------------------------------------------------------------------------------------------------
> base                          1,146,384,132           1,151,216,688            212,431,532
> patch   cgroup disabled       1,163,717,547 (1.51%)   1,165,238,015 ( 1.22%)   215,092,327 ( 1.25%)
> patch   10000000000/1000      1,244,889,136 (8.59%)   1,299,128,502 (12.85%)   243,162,542 (14.47%)
> patch   10000000000/10000     1,253,305,706 (9.33%)   1,299,167,897 (12.85%)   243,175,027 (14.47%)
> patch   10000000000/100000    1,252,374,134 (9.25%)   1,299,314,357 (12.86%)   243,203,923 (14.49%)
> patch   10000000000/1000000   1,254,165,824 (9.40%)   1,299,751,347 (12.90%)   243,288,600 (14.53%)
> --------------------------------------------------------------------------------------------------
> 
> 
> The +1.5% increase in vanilla kernel context switching performance is 
> unfortunate - where does that overhead come from?
> 
> The +9% increase in cgroups context-switching overhead looks rather 
> brutal.

As to those, do they run pipe-test in a cgroup or are you always using
the root cgroup?
