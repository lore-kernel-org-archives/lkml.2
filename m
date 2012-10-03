Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2JCOiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:38:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47427 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2JCOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:37:59 -0400
Date: Wed, 3 Oct 2012 19:59:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20121003142942.GB15253@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <1348486479.11847.46.camel@twins>
 <50604988.2030506@linux.vnet.ibm.com>
 <1348490165.11847.58.camel@twins>
 <50606050.309@linux.vnet.ibm.com>
 <1348494895.11847.64.camel@twins>
 <50606B33.1040102@linux.vnet.ibm.com>
 <5061B437.8070300@linux.vnet.ibm.com>
 <5064101A.5070902@redhat.com>
 <50643745.6010202@linux.vnet.ibm.com>
 <506440AF.9080202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <506440AF.9080202@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100314-5112-0000-0000-00000D097D1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2012-09-27 14:03:59]:

> On 09/27/2012 01:23 PM, Raghavendra K T wrote:
> >>
[...]
> > 2) looking at the result (comparing A & C) , I do feel we have
> > significant in iterating over vcpus (when compared to even vmexit)
> > so We still would need undercommit fix sugested by PeterZ (improving by
> > 140%). ?
> 
> Looking only at the current runqueue?  My worry is that it misses a lot
> of cases.  Maybe try the current runqueue first and then others.
> 

Okay. Do you mean we can have something like

+       if (rq->nr_running == 1 && p_rq->nr_running == 1) {
+               yielded = -ESRCH;
+               goto out_irq;
+       }

in the Peter's patch ?

( I thought lot about && or || . Both seem to have their own cons ).
But that should be only when we have short term imbalance, as PeterZ
told.

I am experimenting all these for V2 patch. Will come back with analysis
and patch.

> Or were you referring to something else?
> 

