Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GWKDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2GWKDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:03:46 -0400
Message-ID: <500D2162.8010209@redhat.com>
Date: Mon, 23 Jul 2012 13:03:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V5 0/3] kvm: Improving directed yield in PLE handler
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 04:37 PM, Raghavendra K T wrote:
> Currently Pause Loop Exit (PLE) handler is doing directed yield to a
> random vcpu on pl-exit. We already have filtering while choosing
> the candidate to yield_to. This change adds more checks while choosing
> a candidate to yield_to.
> 
> On a large vcpu guests, there is a high probability of
> yielding to the same vcpu who had recently done a pause-loop exit. 
> Such a yield can lead to the vcpu spinning again.
> 
> The patchset keeps track of the pause loop exit and gives chance to a
> vcpu which has:
> 
>  (a) Not done pause loop exit at all (probably he is preempted lock-holder)
> 
>  (b) vcpu skipped in last iteration because it did pause loop exit, and
>  probably has become eligible now (next eligible lock holder)
> 
> This concept also helps in cpu relax interception cases which use same handler.
> 

Thanks, applied to 'queue'.


-- 
error compiling committee.c: too many arguments to function


