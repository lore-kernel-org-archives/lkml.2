Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab1GGQxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:53:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:37671 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab1GGQxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:53:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,494,1304319600"; 
   d="scan'208";a="27515696"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
References: <20110707053036.173186930@google.com>
	<20110707112302.GB8227@elte.hu> <1310049528.3282.583.camel@twins>
Date: Thu, 07 Jul 2011 09:52:23 -0700
In-Reply-To: <1310049528.3282.583.camel@twins> (Peter Zijlstra's message of
	"Thu, 07 Jul 2011 16:38:48 +0200")
Message-ID: <m2iprexcc8.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
> +static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> +               unsigned long delta_exec)
> +{
> +       if (!cfs_rq->runtime_enabled)
> +               return;
> +
> +       cfs_rq->runtime_remaining -= delta_exec;
> +       if (cfs_rq->runtime_remaining > 0)
> +               return;
> +
> +       assign_cfs_rq_runtime(cfs_rq);
> +}
>
> generate a call, only to then take the first branch out, marking that

You would need a *LOT* of calls to make up for 9%.

Maybe it's something else? Some profiling first before optimization
is probably a good idea.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
