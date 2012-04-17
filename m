Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2DQHWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:22:19 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36818 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2DQHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:22:17 -0400
Message-ID: <4F8D168B.7090806@linux.vnet.ibm.com>
Date: Tue, 17 Apr 2012 12:36:51 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 <x86@kernel.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 2/6] kvm hypervisor : Add a hypercall to KVM hypervisor
 to support pv-ticketlocks
References: <20120323080503.14568.43092.sendpatchset@codeblue> <20120323080701.14568.97779.sendpatchset@codeblue> <20120412000629.GA32051@amt.cnet> <20120412002909.GD32051@amt.cnet>
In-Reply-To: <20120412002909.GD32051@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12041621-5140-0000-0000-000001156796
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 05:59 AM, Marcelo Tosatti wrote:
> On Wed, Apr 11, 2012 at 09:06:29PM -0300, Marcelo Tosatti wrote:
>> On Fri, Mar 23, 2012 at 01:37:04PM +0530, Raghavendra K T wrote:
>>> From: Srivatsa Vaddagiri<vatsa@linux.vnet.ibm.com>
>>>
[...]

		barrier();
>>
>> Is it always OK to erase the notification, even in case an unrelated
>> event such as interrupt was the source of wakeup?
>
> Note i am only asking whether it is OK to lose a notification, not
> requesting a change to atomic test-and-clear.

Yes.. got your point.
IMO, this is the only (safe) place where it can clear
kicked(pv_unhalted) flag. Since it is going to be runnable.

and you are also right in having concern on unwanted clear of flag
since that would result in vcpu /vm hangs eventually.

Hope I did not miss anything.

>
> It would be nice to have a comment explaining it.
>

Sure will do that

>>

