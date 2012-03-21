Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab2CUAyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:54:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab2CUAyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:54:00 -0400
X-IronPort-AV: E=Sophos;i="4.73,621,1325433600"; 
   d="scan'208";a="4583207"
Message-ID: <4F692723.8050904@cn.fujitsu.com>
Date: Wed, 21 Mar 2012 08:56:03 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com> <4F6854F4.3060703@cn.fujitsu.com> <20120320154517.GG27928@redhat.com>
In-Reply-To: <20120320154517.GG27928@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-21 08:51:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-21 08:51:50,
	Serialize complete at 2012-03-21 08:51:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/20/2012 11:45 PM, Gleb Natapov Wrote:
> On Tue, Mar 20, 2012 at 05:59:16PM +0800, Wen Congyang wrote:
>> At 03/19/2012 03:33 PM, Wen Congyang Wrote:
>>> At 03/08/2012 03:57 PM, Wen Congyang Wrote:
>>>> We can know the guest is paniced when the guest runs on xen.
>>>> But we do not have such feature on kvm.
>>>>
>>>> Another purpose of this feature is: management app(for example:
>>>> libvirt) can do auto dump when the guest is crashed. If management
>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>> he sees the guest is paniced.
>>>>
>>>> I touch the hypervisor instead of using virtio-serial, because
>>>> 1. it is simple
>>>> 2. the virtio-serial is an optional device, and the guest may
>>>>    not have such device.
>>>>
>>>> Changes from v2 to v3:
>>>> 1. correct spelling
>>>>
>>>> Changes from v1 to v2:
>>>> 1. split up host and guest-side changes
>>>> 2. introduce new request flag to avoid changing return values.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>>
>>>
>>> Hi all:
>>>
>>> we neet this feature, but we don't decide how to implement it.
>>> We have two solution:
>>> 1. use vmcall
>>> 2. use virtio-serial.
>>>
>>> I will not change this patch set before we decide how to do it.
>>> Can we make a decision recent days?
>>
>> Anybody can decide which solution to use?
>>
> To make an informed decision we need to have at least raw idea how
> virtio-serial variant will look.

Hmm, I think we can do this:
1. reset the virtio-serial device or reset the port we use to notice
   the host that guest is panicked.
2. write some specific messages to the port

So the port should have fixed name. If this port is opened by the userspace
before the guest is paniced, I am not sure whether we can use it(because a
port only can be opened once at the same time).
We cannot call any function in the module, so we may need to write a simple
driver for virtio-serial(like diskdump's disk driver).

I donot know how to implement it now. But I guess that it may be complicated.

Thanks
Wen Congyang

> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

