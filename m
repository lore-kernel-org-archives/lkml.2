Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313Ab2CFKmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:42:47 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54371 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab2CFKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:42:42 -0500
Message-ID: <4F55EA0D.4040408@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2012 18:42:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] KVM: perf: kvm events analysis tool
References: <4F55D110.2020609@linux.vnet.ibm.com> <20120306090730.GB27238@elte.hu>
In-Reply-To: <20120306090730.GB27238@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030600-7014-0000-0000-000000AF663B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your review, Ingo!

On 03/06/2012 05:07 PM, Ingo Molnar wrote:


> So, your new tool has a similar workflow to:
> 
>   perf kvm record
>   perf kvm report
> 
> but differs from it in terms of events used and in terms of 
> reported output.
> 
> To me it appears that your tool is basically pretty similar to 
> 'perf stat', adapted to KVM, right?
> 
> So, could your new tool's workflow be simplified like this:
> 
>   perf kvm stat ..
> 
> ?
> 
> To automatically stat all vcpus in the system, the well-known 
> -a/--all-cpus system-wide method could be used:
> 
>   perf kvm stat -a ...
> 
> with stat output following immediately after it has finished.
> 


Actually, the stat information has already been included in the report.


> It should also be possible to use those new events in a 
> recording fashion - a new, rather logical command sub-space 
> could be used for that:
> 
>  perf kvm stat record ...
>  perf kvm stat report ...
> 
> [ This could be expanded to regular 'perf stat' as well: 'perf 
>   stat record' and 'perf stat report' would be useful - but I 
>   suspect that's outside the scope of your patches. ]
> 


I totally agree with you except i prefer 'perf kvm events' to
'perf kvm stat' :) : it records some specified kvm events and
smartly analyze it. I think it matches its doing better.


