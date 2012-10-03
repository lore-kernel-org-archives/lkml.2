Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2JCR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:26:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2JCR0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:26:22 -0400
Message-ID: <506C7524.2010103@redhat.com>
Date: Wed, 03 Oct 2012 19:25:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com> <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com> <20121003142942.GB15253@linux.vnet.ibm.com>
In-Reply-To: <20121003142942.GB15253@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 04:29 PM, Raghavendra K T wrote:
> * Avi Kivity <avi@redhat.com> [2012-09-27 14:03:59]:
> 
>> On 09/27/2012 01:23 PM, Raghavendra K T wrote:
>> >>
> [...]
>> > 2) looking at the result (comparing A & C) , I do feel we have
>> > significant in iterating over vcpus (when compared to even vmexit)
>> > so We still would need undercommit fix sugested by PeterZ (improving by
>> > 140%). ?
>> 
>> Looking only at the current runqueue?  My worry is that it misses a lot
>> of cases.  Maybe try the current runqueue first and then others.
>> 
> 
> Okay. Do you mean we can have something like
> 
> +       if (rq->nr_running == 1 && p_rq->nr_running == 1) {
> +               yielded = -ESRCH;
> +               goto out_irq;
> +       }
> 
> in the Peter's patch ?
> 
> ( I thought lot about && or || . Both seem to have their own cons ).
> But that should be only when we have short term imbalance, as PeterZ
> told.

I'm missing the context.  What is p_rq?

What I mean was:

  if can_yield_to_process_in_current_rq
     do that
  else if can_yield_to_process_in_other_rq
     do that
  else
     return -ESRCH


-- 
error compiling committee.c: too many arguments to function
