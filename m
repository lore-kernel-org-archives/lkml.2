Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2GJLYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:24:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51664 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2GJLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:24:20 -0400
Message-ID: <4FFC106E.4040407@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 16:52:22 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 1/2] kvm vcpu: Note down pause loop exit
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062032.24030.10454.sendpatchset@codeblue> <4FFB5D8E.70402@redhat.com>
In-Reply-To: <4FFB5D8E.70402@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071001-7014-0000-0000-0000018907B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 04:09 AM, Rik van Riel wrote:
> On 07/09/2012 02:20 AM, Raghavendra K T wrote:
>
>> @@ -484,6 +484,13 @@ struct kvm_vcpu_arch {
>> u64 length;
>> u64 status;
>> } osvw;
>> +
>> + /* Pause loop exit optimization */
>> + struct {
>> + bool pause_loop_exited;
>> + bool dy_eligible;
>> + } plo;
>
> I know kvm_vcpu_arch is traditionally not a well documented
> structure, but it would be really nice if each variable inside
> this sub-structure could get some documentation.

Sure. Will document it.

>
> Also, do we really want to introduce another acronym here?
>
> Or would we be better off simply calling this struct .ple,
> since that is a name people are already familiar with.

Yes. it makes sense to have .ple.


