Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2EBNZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:25:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:18811 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab2EBNZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:25:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95499984"
Message-ID: <4FA13599.7080308@intel.com>
Date: Wed, 02 May 2012 21:24:41 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: Borislav Petkov <bp@amd64.org>, andi.kleen@intel.com,
        tim.c.chen@linux.intel.com, jeremy@goop.org, chrisw@sous-sol.org,
        akataria@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rostedt@goodmis.org, fweisbec@gmail.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        paul.gortmaker@windriver.com, dhowells@redhat.com,
        fenghua.yu@intel.com, yinghai@kernel.org, cpw@sgi.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com> <1335603099-2624-3-git-send-email-alex.shi@intel.com> <20120430105440.GC9303@aftab.osrc.amd.com> <4FA0FD39.9060908@intel.com> <20120502093815.GB12914@aftab.osrc.amd.com> <4FA11CC7.5040302@intel.com> <CAPa8GCDhGfuYEemdsnUZwh=O6Nco1PH1JgiruvWw3400yz9S8w@mail.gmail.com>
In-Reply-To: <CAPa8GCDhGfuYEemdsnUZwh=O6Nco1PH1JgiruvWw3400yz9S8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 09:04 PM, Nick Piggin wrote:

> On 2 May 2012 21:38, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/02/2012 05:38 PM, Borislav Petkov wrote:
>>
>>> On Wed, May 02, 2012 at 05:24:09PM +0800, Alex Shi wrote:
>>>> For some of scenario, above equation can be modified as:
>>>> (512 - X) * 100ns(assumed TLB refill cost) = X * 140ns(assumed invlpg cost)
> 
> It should not be that optimistic, because that equation assumes every
> unflushed entry saves a TLB refill too.
> 


Yes, it is just ideal scenario to do analysis. In the code, the judgment
depends on the 'active entries' instead of the fixed TLB line number.

active entries = min(this process's page number, TLB line number)

> I think it is always a good idea to make such fundamental primitives
> cheaper though.
> 


