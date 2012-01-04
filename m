Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2ADROK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab2ADROH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:14:07 -0500
Message-ID: <4F0488AB.6000003@redhat.com>
Date: Wed, 04 Jan 2012 19:13:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com> <20120104145602.GB8333@linux.vnet.ibm.com>
In-Reply-To: <20120104145602.GB8333@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 04:56 PM, Srivatsa Vaddagiri wrote:
> * Avi Kivity <avi@redhat.com> [2012-01-04 16:41:58]:
>
> > > Here are some observation related to Baseline-only(8vm case)
> > >
> > >               | ple_gap=128 | ple_gap=64 | ple_gap=256 | ple_window=2048
> > > --------------+-------------+------------+-------------+----------------
> > > EbzyRecords/s |    2247.50  |    2132.75 |    2086.25  |      1835.62
> > > PauseExits    | 7928154.00  | 6696342.00 | 7365999.00  |  50319582.00
> > >
> > > With ple_window = 2048, PauseExits is more than 6times the default case
> > 
> > So it looks like the default is optimal, at least wrt the cases you
> > tested and your test workload.
>
> The default case still lags considerably behind the results we are seeing with
> gang scheduling. One more interesting data point would be to see how
> many PLE exits we are seeing when the vcpu is spinning in
> flush_tlb_others_ipi(). Is there any easy way to determine that?
>

You could get an exit trace (trace-cmd -e kvm:kvm_exit) and filter on
PLE exits; the trace contains the guest %rip, so you could match it
against flush_tlb_others_ipi().

-- 
error compiling committee.c: too many arguments to function

