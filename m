Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2GIW2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:28:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2GIW2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:28:21 -0400
Message-ID: <4FFB5AF3.4010805@redhat.com>
Date: Mon, 09 Jul 2012 18:28:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue>
In-Reply-To: <20120709062012.24030.37154.sendpatchset@codeblue>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 02:20 AM, Raghavendra K T wrote:
> Currently Pause Looop Exit (PLE) handler is doing directed yield to a
> random VCPU on PL exit. Though we already have filtering while choosing
> the candidate to yield_to, we can do better.
>
> Problem is, for large vcpu guests, we have more probability of yielding
> to a bad vcpu. We are not able to prevent directed yield to same guy who
> has done PL exit recently, who perhaps spins again and wastes CPU.
>
> Fix that by keeping track of who has done PL exit. So The Algorithm in series
> give chance to a VCPU which has:
>
>   (a) Not done PLE exit at all (probably he is preempted lock-holder)
>
>   (b) VCPU skipped in last iteration because it did PL exit, and probably
>   has become eligible now (next eligible lock holder)
>
> Future enhancemnets:

Your patch series looks good to me. Simple changes with a
significant result.

However, the simple heuristic could use some comments :)

-- 
All rights reversed
