Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2GKOBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:01:52 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59156 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab2GKOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:01:48 -0400
Message-ID: <4FFD86CE.9040501@linux.vnet.ibm.com>
Date: Wed, 11 Jul 2012 19:29:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: habanero@linux.vnet.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <1341870457.2909.27.camel@oc2024037011.ibm.com> <4FFD4091.8040804@redhat.com>
In-Reply-To: <4FFD4091.8040804@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071103-5490-0000-0000-000001C34D8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:30 PM, Avi Kivity wrote:
> On 07/10/2012 12:47 AM, Andrew Theurer wrote:
>>
>> For the cpu threads in the host that are actually active (in this case
>> 1/2 of them), ~50% of their time is in kernel and ~43% in guest.  This
>> is for a no-IO workload, so that's just incredible to see so much cpu
>> wasted.  I feel that 2 important areas to tackle are a more scalable
>> yield_to() and reducing the number of pause exits itself (hopefully by
>> just tuning ple_window for the latter).
>
> One thing we can do is autotune ple_window.  If a ple exit fails to wake
> anybody (because all vcpus are either running, sleeping, or in ple
> exits) then we deduce we are not overcommitted and we can increase the
> ple window.  There's the question of how to decrease it again though.
>

I see some problem here, If I interpret situation correctly. What
happens if we have two guests with one VM having no over-commit and 
other with high over-commit. (except when we have gang scheduling).

Rather we should have something tied to VM rather than rigid PLE
window.

