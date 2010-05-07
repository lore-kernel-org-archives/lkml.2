Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab0EGQUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:20:54 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:23236 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab0EGQUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:20:52 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "K. Y. Srinivasan" <ksrinivasan@novell.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vadim Rozenfeld <vrozenfe@redhat.com>, "Avi Kivity" <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] x86: detect running on a HyperV system
Thread-Topic: [PATCH] x86: detect running on a HyperV system
Thread-Index: AQHK7U+60FewITzY+EK5X6yR8mcouJJFOxaAgAABZQCAAG1QgIAA6emA//+ScEA=
Date: Fri, 7 May 2010 16:20:47 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5621AFFAA7C@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <20100506190841.GA1605@kroah.com> <4BE314CD.6060701@zytor.com>
 <20100506191816.GA20874@kroah.com>
 <4BE371AB.2000806@zytor.com>,<20100507154643.GA19847@kroah.com>
In-Reply-To: <20100507154643.GA19847@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



SNIP SNIP SNIP----------
> From: Greg KH [greg@kroah.com]    -    Friday, May 07, 2010 8:46 AM
>
>[KY added to the To:, sorry for not including him earlier, he wrote this
>code]

On Thu, May 06, 2010 at 06:49:31PM -0700, H. Peter Anvin wrote:
>> On 05/06/2010 12:18 PM, Greg KH wrote:
>> > On Thu, May 06, 2010 at 12:13:17PM -0700, H. Peter Anvin wrote:
>> >> On 05/06/2010 12:08 PM, Greg KH wrote:
>> Okay... we write something called x86_hyper_features, but it isn't
>> actually used for anything.  I'm assuming based on what I can see in
>> <asm/hyperv.h> that it is almost certainly not anything CPU-based.  I
>> really don't like a random field that can be stuffed with information
>> from random locations, and it doesn't look like it's even a flag field
>> in any meaningful way.  Worse, the field is just used to mix bits from
>> two different CPUID levels at what appears to be a completely arbitrary
>> boundary:
>>
>>         /*
>>          * Extract the features, recommendations etc.
>>          * The first 9 bits will be used to track hypervisor features.
>>          * The next 6 bits will be used to track the hypervisor
>>          * recommendations.
>>          */
>>         cpuid(HYPERV_CPUID_FEATURES, &eax, &ebx, &ecx, &edx);
>>         c->x86_hyper_features |= (eax & 0x1ff);
>>
>>         cpuid(HYPERV_CPUID_ENLIGHTMENT_INFO, &eax, &ebx, &ecx, &edx);
>>         c->x86_hyper_features |= ((eax & 0x3f) << 9);
>>
>> Why 9?  Why 6?  The only thing that I can think of that justifies those
>> particular numbers is what the *current* version of Hyper-V does.
>
>I think that is what Hyper-V is saying it will always do.  Hank?  Any
>help here?

That is correct. Hyper-V will always do this.

For functionality like a timesource, we need to get to hyper-v the way Ky did in his
code. There is no messaging for it like IDE/SCSI/Network and the like.

My understanding is that more information is going to be contained in these areas
once Windows 8 is more defined. I know Windows 8 will give us changes but we do
not know yet what they are. And I will not untill much later in the year. They are
designing some of the low level stuff there right now.

I know that some of the messaging protocols will change regarding networking.

Hank.