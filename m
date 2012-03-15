Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab2COHAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:00:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55772 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756780Ab2COG75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:59:57 -0400
X-IronPort-AV: E=Sophos;i="4.73,589,1325433600"; 
   d="scan'208";a="4540464"
Message-ID: <4F6193D8.8050101@cn.fujitsu.com>
Date: Thu, 15 Mar 2012 15:01:44 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F606A7C.9090900@cn.fujitsu.com>	<4F606DCC.3020908@redhat.com>	<4F60726E.3090807@cn.fujitsu.com>	<4F607325.6050607@redhat.com>	<20120314104608.GU2304@redhat.com>	<4F607789.4010109@redhat.com>	<4F607CE4.2060809@cn.fujitsu.com>	<4F609822.7050502@redhat.com>	<20120314131415.GB2304@redhat.com>	<4F609A15.5020902@redhat.com>	<20120314132552.GC2304@redhat.com> <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com>
In-Reply-To: <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 14:57:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 14:57:51,
	Serialize complete at 2012-03-15 14:57:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/15/2012 02:46 AM, Eric Northup Wrote:
> On Wed, Mar 14, 2012 at 6:25 AM, Gleb Natapov <gleb@redhat.com> wrote:
> 
>> On Wed, Mar 14, 2012 at 03:16:05PM +0200, Avi Kivity wrote:
>>> On 03/14/2012 03:14 PM, Gleb Natapov wrote:
>>>> On Wed, Mar 14, 2012 at 03:07:46PM +0200, Avi Kivity wrote:
>>>>> On 03/14/2012 01:11 PM, Wen Congyang wrote:
>>>>>>>
>>>>>>> I don't think we want to use the driver.  Instead, have a small
>> piece of
>>>>>>> code that resets the device and pushes out a string (the panic
>> message?)
>>>>>>> without any interrupts etc.
>>>>>>>
>>>>>>> It's still going to be less reliable than a hypercall, I agree.
>>>>>>
>>>>>> Do you still want to use complicated and less reliable way?
>>>>>
>>>>> Are you willing to try it out and see how complicated it really is?
>>>>>
>>>>> While it's more complicated, it's also more flexible.  You can
>>>>> communicate the panic message, whether the guest is attempting a
>> kdump
>>>>> and its own recovery or whether it wants the host to do it, etc., you
>>>>> can communicate less severe failures like oopses.
>>>>>
>>>> hypercall can take arguments to achieve the same.
>>>
>>> It has to be designed in advance; and every time we notice something's
>>> missing we have to update the host kernel.
>>>
>>
>> We and in the designed stage now. Not to late to design something flexible
>> :) Panic hypercall can take GPA of a buffer where host puts panic info
>> as a parameter.  This buffer can be read by QEMU and passed to management.
>>
> 
> If a host kernel change is in the works, I think it might be cleanest to
> have the host kernel export a new kind of VCPU exit for unhandled-by-KVM
> hypercalls.  Then usermode can respond to the hypercall as appropriate.
>  This would permit adding or changing future hypercalls without host kernel
> changes.
> 
> "Guest panic" is almost the definition of not-a-fast-path, and so what's
> the reason to handle it in the host kernel.
> 
> Punting to user-space wouldn't be a magic bullet for getting good
> interfaces designed, but in my opinion it is a better place to be doing
> them.
> 

Do you mean that: the guest execute vmcall instruction, and the host kernel
exits to userspace. The userspace will deal with the vmexit?

Thanks
Wen Congyang
