Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2GPQKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab2GPQKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:10:51 -0400
Message-ID: <50043CF3.8020903@redhat.com>
Date: Mon, 16 Jul 2012 12:10:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC V4 3/3] kvm: Choose better candidate for directed
 yield
References: <20120716082445.23477.15128.sendpatchset@codeblue.in.ibm.com> <20120716082529.23477.91096.sendpatchset@codeblue.in.ibm.com> <5003E7ED.2030701@redhat.com>
In-Reply-To: <5003E7ED.2030701@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 06:07 AM, Avi Kivity wrote:

>> +{
>> +	bool eligible;
>> +
>> +	eligible = !vcpu->ple.cpu_relax_intercepted ||
>> +			(vcpu->ple.cpu_relax_intercepted&&
>> +			 vcpu->ple.dy_eligible);
>> +
>> +	if (vcpu->ple.cpu_relax_intercepted)
>> +		vcpu->ple.dy_eligible = !vcpu->ple.dy_eligible;
>
> Probably should assign 'true', since the previous value is essentially
> random.

I suspect the intended purpose of this conditional is to
flip the eligibility of a vcpu for being selected as a
direct yield target.

In other words, that bit of the code is correct.

-- 
All rights reversed
