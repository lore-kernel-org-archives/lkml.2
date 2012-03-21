Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2CUTNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:13:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34126 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2CUTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:12:54 -0400
Message-ID: <4F6A2832.9080306@codemonkey.ws>
Date: Wed, 21 Mar 2012 14:12:50 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, kvm list <kvm@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com> <4F607CE4.2060809@cn.fujitsu.com> <4F609822.7050502@redhat.com> <20120314131415.GB2304@redhat.com> <4F609A15.5020902@redhat.com> <20120314132552.GC2304@redhat.com> <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com> <20120315103923.GL2304@redhat.com> <4F61D1AF.4040603@siemens.com> <4F61D688.5040406@redhat.com>
In-Reply-To: <4F61D688.5040406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 06:46 AM, Avi Kivity wrote:
> On 03/15/2012 01:25 PM, Jan Kiszka wrote:
>>>>
>>> There was such vm exit (KVM_EXIT_HYPERCALL), but it was deemed to be a
>>> bad idea.
>>
>> BTW, this would help a lot in emulating hypercalls of other hypervisors
>> (or of KVM's VAPIC in the absence of in-kernel irqchip - I had to jump
>> through hoops therefore) in user space. Not all those hypercall handlers
>> actually have to reside in the KVM module.
>>
>
> That is true.  On the other hand the hypercall ABI might go to pieces if
> there was no central implementation.

Just declare that outl 0x505 is a megaultracall and s/vmcall/outb/g and call it 
a day.

The performance difference between vmcall and outl is so tiny compared to the 
cost of dropping to userspace that it really doesn't matter which instruction is 
used.

Regards,

Anthony Liguori

>

