Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2AJOlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 09:41:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33145 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2AJOlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 09:41:31 -0500
Message-ID: <1326206478.2442.111.camel@twins>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Date: Tue, 10 Jan 2012 15:41:18 +0100
In-Reply-To: <4F0C4BF0.9090809@linux.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	 <1326103578.2442.50.camel@twins>
	 <20120110001445.GA20542@linux-youquan.bj.intel.com>
	 <1326107156.2442.59.camel@twins>
	 <20120110055856.GA23741@linux-youquan.bj.intel.com>
	 <1326153163.2366.7.camel@sbsiddha-mobl2> <20120110091805.GA28024@elte.hu>
	 <4F0C4BF0.9090809@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 06:32 -0800, Arjan van de Ven wrote:
> 
> a very good default would be to keep all tasks on one package until half
> the cores in the package are busy, and then start spreading out. 

Does that still make sense when there's strong NUMA preference? By
forcing stuff on a single package you increase the number of remote
memory fetches (which generally generate more stalls), also the memory
controllers need to stay awake anyway.


