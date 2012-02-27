Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2B0EN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:13:28 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39031 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2B0EN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:13:27 -0500
Date: Mon, 27 Feb 2012 09:42:59 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] sched: Avoid unnecessary work in reweight_entity
Message-ID: <20120227041259.GA2331@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4F308E25.7060101@linux.vnet.ibm.com>
 <4F31D9B2.5090501@linux.vnet.ibm.com>
 <4F3D0F41.1010205@linux.vnet.ibm.com>
 <1329402561.2293.225.camel@twins>
 <4F3DEDC3.4010004@linux.vnet.ibm.com>
 <4F3F025B.5010400@linux.vnet.ibm.com>
 <1329743311.2293.341.camel@twins>
 <4F4617AB.2080401@linux.vnet.ibm.com>
 <4F46F105.2000702@linux.vnet.ibm.com>
 <4F48E882.6090409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F48E882.6090409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022618-0260-0000-0000-0000009AD6D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Wang <wangyun@linux.vnet.ibm.com> [2012-02-25 21:56:18]:

> Hi, Peter
> 
> I have collected more testing data, here is the test results:
> 
> Machine:	ThinkPad T420
> OS:		Ubuntu 11.10
> Benchmark:	time make -j14 (build kernel)

Is that benchmark run in root (cpu) cgroup? If so, reweight_entity() should not
kick in at all.

static void update_cfs_shares(struct cfs_rq *cfs_rq)
{

        ..

        if (!se || throttled_hierarchy(cfs_rq))
                return;

        ..

	reweight_entity();
}

If you want to stress reweight_entity() create several (cpu) cgroups
and launch workload like kernbench in each of them ..

- vatsa

