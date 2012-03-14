Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858Ab2CNLJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:09:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12173 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab2CNLJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:09:41 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325433600"; 
   d="scan'208";a="4533868"
Message-ID: <4F607CE4.2060809@cn.fujitsu.com>
Date: Wed, 14 Mar 2012 19:11:32 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <4F606DCC.3020908@redhat.com> <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com>
In-Reply-To: <4F607789.4010109@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:07:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:07:36,
	Serialize complete at 2012-03-14 19:07:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/14/2012 06:48 PM, Avi Kivity Wrote:
> On 03/14/2012 12:46 PM, Gleb Natapov wrote:
>> On Wed, Mar 14, 2012 at 12:29:57PM +0200, Avi Kivity wrote:
>>> On 03/14/2012 12:26 PM, Wen Congyang wrote:
>>>>>> If so, is this channel visible to guest userspace? If the channle is visible to guest
>>>>>> userspace, the program running in userspace may write the same message to the channel.
>>>>>>
>>>>>
>>>>> Surely there's some kind of access control on channels.
>>>>
>>>> The virtio-serial depends on more things than touching the hypervisor. So I think touching
>>>> the hypervisor is more reliable than using virtio-serial device, and it is very simple and
>>>> easy to use.
>>>>
>>>> If we pass something from guest userspace to host, we can use virtio-serial. But If we pass
>>>> something from guest kernelspace to host, I still prefer to touch the hypervisor.
>>>
>>> There's no argument that it's easier.  My concern is different, we're
>>> adding more and more stuff to the hypervisor because it's easier, which
>>> bloats it.  Every time we do it we add to compatibility and security
>>> problems.
>>>
>>> The panic notification is *really* simple, so I don't expect it to cause
>>> a lot of problems.  But still, if it's possible not to change the
>>> hypervisor, we must make an effort in that direction.
>>>
>> One more point against using virtio-serial is that it will be likely
>> compiled as a module which means panic during early boot will not be
>> reported.
> 
> I don't think we want to use the driver.  Instead, have a small piece of
> code that resets the device and pushes out a string (the panic message?)
> without any interrupts etc.
> 
> It's still going to be less reliable than a hypercall, I agree.

Do you still want to use complicated and less reliable way?

I think the other ones prefer to touch the hypervisor.

Thanks
Wen Congyang

