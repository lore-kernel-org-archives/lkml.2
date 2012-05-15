Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2EON6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:58:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:23764 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2EON6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:58:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140866821"
Message-ID: <4FB260F1.5040800@intel.com>
Date: Tue, 15 May 2012 21:58:09 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Borislav Petkov <bp@amd64.org>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>  <1336626013-28413-4-git-send-email-alex.shi@intel.com>  <20120510084213.GD30055@aftab.osrc.amd.com> <4FAB84B6.7060706@intel.com>  <4FAE18D0.6050001@intel.com> <20120513111328.GD28863@aftab.osrc.amd.com>  <4FB1AC03.2070407@intel.com> <20120515103307.GB27153@aftab.osrc.amd.com>  <1337080582.27694.40.camel@twins>  <20120515115638.GE27153@aftab.osrc.amd.com> <1337083243.27020.153.camel@laptop>
In-Reply-To: <1337083243.27020.153.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 08:00 PM, Peter Zijlstra wrote:

> On Tue, 2012-05-15 at 13:56 +0200, Borislav Petkov wrote:
>> On Tue, May 15, 2012 at 01:16:22PM +0200, Peter Zijlstra wrote:
>>> Wouldn't all this become much prettier if you rip out that
>>> multi-vector stuff?
>>
>> multi-vector stuff? Please elaborate.
> 
> The INVALIDATE_TLB_VECTOR muck:
> 
>                 apic->send_IPI_mask(to_cpumask(f->flush_cpumask),
>                               INVALIDATE_TLB_VECTOR_START + sender);
> 
> and simply use:
> 
>  smp_call_function()
> 


I am trying this following the patchset.
but that should another work thread.
