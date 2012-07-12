Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2GLTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:25:59 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53626 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab2GLTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:25:57 -0400
Message-ID: <4FFF2440.40807@linux.vnet.ibm.com>
Date: Fri, 13 Jul 2012 00:53:44 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V3 0/3] kvm: Improving directed yield in PLE handler
References: <20120712191712.30440.68944.sendpatchset@codeblue>
In-Reply-To: <20120712191712.30440.68944.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071209-6102-0000-0000-000001DEBE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 12:47 AM, Raghavendra K T wrote:
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
>   (a) Not done pause loop exit at all (probably he is preempted lock-holder)
>
>   (b) vcpu skipped in last iteration because it did pause loop exit, and
>   probably has become eligible now (next eligible lock holder)
>
> This concept also helps in cpu relax interception cases which use same handler.

The patches are tested on x86 only since I don't have access to s390
machine. Please let me know if changes are ok on s390.

