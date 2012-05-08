Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2EHBOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 21:14:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46637 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2EHBOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 21:14:08 -0400
Message-ID: <4FA8733B.70402@linux.vnet.ibm.com>
Date: Tue, 08 May 2012 06:43:31 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120507082928.GI16608@gmail.com> <4FA7888F.80505@redhat.com> <4FA7AAD8.6050003@linux.vnet.ibm.com> <4FA7BABA.4040700@redhat.com> <4FA7CC05.50808@linux.vnet.ibm.com> <4FA7CCA2.4030408@redhat.com> <4FA7D06B.60005@linux.vnet.ibm.com> <20120507134611.GB5533@linux.vnet.ibm.com> <4FA7D2E5.1020607@redhat.com> <4FA8579C.3000205@goop.org>
In-Reply-To: <4FA8579C.3000205@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12050715-1618-0000-0000-0000017F6723
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 04:45 AM, Jeremy Fitzhardinge wrote:
> On 05/07/2012 06:49 AM, Avi Kivity wrote:
>> On 05/07/2012 04:46 PM, Srivatsa Vaddagiri wrote:
>>> * Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>  [2012-05-07 19:08:51]:
>>>
>>>> I 'll get hold of a PLE mc  and come up with the numbers soon. but I
>>>> 'll expect the improvement around 1-3% as it was in last version.
>>> Deferring preemption (when vcpu is holding lock) may give us better than 1-3%
>>> results on PLE hardware. Something worth trying IMHO.
>> Is the improvement so low, because PLE is interfering with the patch, or
>> because PLE already does a good job?
>
> How does PLE help with ticket scheduling on unlock?  I thought it would
> just help with the actual spin loops.

Hmm. This strikes something to me. I think I should replace while 1 hog
in with some *real job*  to measure over-commit case. I hope to see
greater improvements because of fairness and scheduling of the
patch-set.

May be all the way I was measuring something equal to 1x case.

