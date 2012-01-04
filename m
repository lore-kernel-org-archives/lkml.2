Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2ADO5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:57:35 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35131 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2ADO5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:57:32 -0500
Date: Wed, 4 Jan 2012 20:26:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20120104145602.GB8333@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <4EF1B85F.7060105@redhat.com>
 <877h1o9dp7.fsf@linux.vnet.ibm.com>
 <20111223103620.GD4749@elte.hu>
 <4EF701C7.9080907@redhat.com>
 <20111230095147.GA10543@elte.hu>
 <878vlu4bgh.fsf@linux.vnet.ibm.com>
 <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
 <4F017AD2.3090504@redhat.com>
 <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
 <4F046536.5080207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F046536.5080207@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010414-5806-0000-0000-0000110E328A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2012-01-04 16:41:58]:

> > Here are some observation related to Baseline-only(8vm case)
> >
> >               | ple_gap=128 | ple_gap=64 | ple_gap=256 | ple_window=2048
> > --------------+-------------+------------+-------------+----------------
> > EbzyRecords/s |    2247.50  |    2132.75 |    2086.25  |      1835.62
> > PauseExits    | 7928154.00  | 6696342.00 | 7365999.00  |  50319582.00
> >
> > With ple_window = 2048, PauseExits is more than 6times the default case
> 
> So it looks like the default is optimal, at least wrt the cases you
> tested and your test workload.

The default case still lags considerably behind the results we are seeing with
gang scheduling. One more interesting data point would be to see how
many PLE exits we are seeing when the vcpu is spinning in
flush_tlb_others_ipi(). Is there any easy way to determine that?

- vatsa

