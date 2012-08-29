Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2H2Ujh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 16:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2H2Ujg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 16:39:36 -0400
Message-ID: <503E7E6D.8030302@redhat.com>
Date: Wed, 29 Aug 2012 16:41:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>
Subject: Re: KS/Plumbers: c-state governor BOF
References: <5037B36A.8000209@redhat.com>
In-Reply-To: <5037B36A.8000209@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 01:01 PM, Rik van Riel wrote:

> Since a good number of us will be in San Diego next week, at
> Kernel Summit / Plumbers / etc, I will organize a c-state
> governor BOF for those who are interested.

Here are the note from today's c-state governor BOF session:

- idle time estimator can be improved to return more
   conservative values
- have a trace point to verify how well idle time estimation works,
   returning expected idle time for the current algorithm, expected
   idle time for a test algorithm, and actually measured idle time
- we can objectively measure whether one idle time estimation
   algorithm is better than another
- example: last 8 idle times are 180 200 30 210 1000 150 10000 190
   - average idle time around 1500, but not typical
   - typical idle time just under 200
   - almost all idle time spent in one interval
- scheduler and cpufreq people also want idle time
   statistics, idea is to move the idle time statistics
   to the scheduler
- having idle time statistics in the scheduler allows
   the stats to be migrated when the scheduler migrates
   a task
- interface: expected idle time, demotion time
   - if we sleep much more than the expected idle time, put
     CPU into a deeper c-state
   - on x86 timed mwait could be used
   - generic timer code would be usable too
   - take into account both the idle statistics and power break-even




