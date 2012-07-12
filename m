Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab2GLMcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:32:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998Ab2GLMb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:31:58 -0400
Message-ID: <4FFEC3A8.6000000@redhat.com>
Date: Thu, 12 Jul 2012 15:31:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
References: <20120709062012.24030.37154.sendpatchset@codeblue> <1341870457.2909.27.camel@oc2024037011.ibm.com> <4FFD4091.8040804@redhat.com> <4FFD86CE.9040501@linux.vnet.ibm.com> <4FFD874B.4090606@linux.vnet.ibm.com> <4FFE8787.2020806@redhat.com> <4FFE89E7.2080409@linux.vnet.ibm.com>
In-Reply-To: <4FFE89E7.2080409@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 11:25 AM, Raghavendra K T wrote:
>>
>> The problem occurs even with no overcommit at all.  One vcpu is in a
>> legitimately long pause loop.  All those exits accomplish nothing, since
>> all vcpus are scheduled.  Better to let it spin in guest mode.
>>
> 
> I agree. One idea is we can have a scan_window to limit the scan of all
> n vcpus each time we enter vcpu_spin, to say 2*log n initially;

Not sure I agree.  The subset that we scan is in no way special, there's
no reason to suppose it would be effective.

We can make the loop exit time scale with the number of vcpus to account
for the greater effort needed to wake a vcpu.


-- 
error compiling committee.c: too many arguments to function


