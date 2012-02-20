Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2BTIOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:14:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38255 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2BTIOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:14:36 -0500
Date: Mon, 20 Feb 2012 09:14:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20120220081416.GE30810@elte.hu>
References: <87pqf5mqg4.fsf@abhimanyu.in.ibm.com>
 <4F017AD2.3090504@redhat.com>
 <87mxa3zqm1.fsf@abhimanyu.in.ibm.com>
 <4F046536.5080207@redhat.com>
 <4F048295.1050907@redhat.com>
 <4F04898B.1080600@redhat.com>
 <1325712710.3084.10.camel@laptop>
 <4F04C789.40209@redhat.com>
 <20120105091059.GA3249@elte.hu>
 <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwe6ork3.fsf@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikunj A Dadhania <nikunj@linux.vnet.ibm.com> wrote:

> > Here it would massively improve performance - without 
> > regressing the scheduler code massively.
> 
> I tried doing an experiment with the flush_tlb_others_ipi. 
> This depends on Raghu's "kvm : Paravirt-spinlock support for 
> KVM guests" (https://lkml.org/lkml/2012/1/14/66), which has 
> new hypercall for kicking another vcpu out of halt.
> 
>   Here are the results from non-PLE hardware. Running ebizzy 
>   workload inside the VMs. The table shows the ebizzy score - 
>   Records/sec.
> 
>   8CPU Intel Xeon, HT disabled, 64 bit VM(8vcpu, 1G RAM)
> 
>   +--------+------------+------------+-------------+
>   |        |  baseline  |   gang     |   pv_flush  |
>   +--------+------------+------------+-------------+
>   |   2VM  |   3979.50  |   8818.00  |   11002.50  |
>   |   4VM  |   1817.50  |   6236.50  |    6196.75  |
>   |   8VM  |    922.12  |   4043.00  |    4001.38  |
>   +--------+------------+------------+-------------+

Very nice results!

Seems like the PV approach is massively faster on 2 VMs than 
even the gang scheduling hack, because it attacks the problem
at its root, not just the symptom.

The patch is also an order of magnitude simpler. Gang 
scheduling, R.I.P.

Thanks,

	Ingo
