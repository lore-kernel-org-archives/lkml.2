Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010Ab2COL0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:26:00 -0400
Received: from david.siemens.de ([192.35.17.14]:19842 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab2COLZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:25:59 -0400
Message-ID: <4F61D1AF.4040603@siemens.com>
Date: Thu, 15 Mar 2012 12:25:35 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Eric Northup <digitaleric@google.com>, Avi Kivity <avi@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com> <4F607CE4.2060809@cn.fujitsu.com> <4F609822.7050502@redhat.com> <20120314131415.GB2304@redhat.com> <4F609A15.5020902@redhat.com> <20120314132552.GC2304@redhat.com> <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com> <20120315103923.GL2304@redhat.com>
In-Reply-To: <20120315103923.GL2304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-15 11:39, Gleb Natapov wrote:
> On Wed, Mar 14, 2012 at 11:46:08AM -0700, Eric Northup wrote:
>> On Wed, Mar 14, 2012 at 6:25 AM, Gleb Natapov <gleb@redhat.com> wrote:
>>
>>> On Wed, Mar 14, 2012 at 03:16:05PM +0200, Avi Kivity wrote:
>>>> On 03/14/2012 03:14 PM, Gleb Natapov wrote:
>>>>> On Wed, Mar 14, 2012 at 03:07:46PM +0200, Avi Kivity wrote:
>>>>>> On 03/14/2012 01:11 PM, Wen Congyang wrote:
>>>>>>>>
>>>>>>>> I don't think we want to use the driver.  Instead, have a small
>>> piece of
>>>>>>>> code that resets the device and pushes out a string (the panic
>>> message?)
>>>>>>>> without any interrupts etc.
>>>>>>>>
>>>>>>>> It's still going to be less reliable than a hypercall, I agree.
>>>>>>>
>>>>>>> Do you still want to use complicated and less reliable way?
>>>>>>
>>>>>> Are you willing to try it out and see how complicated it really is?
>>>>>>
>>>>>> While it's more complicated, it's also more flexible.  You can
>>>>>> communicate the panic message, whether the guest is attempting a
>>> kdump
>>>>>> and its own recovery or whether it wants the host to do it, etc., you
>>>>>> can communicate less severe failures like oopses.
>>>>>>
>>>>> hypercall can take arguments to achieve the same.
>>>>
>>>> It has to be designed in advance; and every time we notice something's
>>>> missing we have to update the host kernel.
>>>>
>>>
>>> We and in the designed stage now. Not to late to design something flexible
>>> :) Panic hypercall can take GPA of a buffer where host puts panic info
>>> as a parameter.  This buffer can be read by QEMU and passed to management.
>>>
>>
>> If a host kernel change is in the works, I think it might be cleanest to
>> have the host kernel export a new kind of VCPU exit for unhandled-by-KVM
>> hypercalls.  Then usermode can respond to the hypercall as appropriate.
>>  This would permit adding or changing future hypercalls without host kernel
>> changes.
>>
> There was such vm exit (KVM_EXIT_HYPERCALL), but it was deemed to be a
> bad idea.

BTW, this would help a lot in emulating hypercalls of other hypervisors
(or of KVM's VAPIC in the absence of in-kernel irqchip - I had to jump
through hoops therefore) in user space. Not all those hypercall handlers
actually have to reside in the KVM module.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
