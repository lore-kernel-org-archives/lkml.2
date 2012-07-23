Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2GWCCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:02:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26180 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab2GWCCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:02:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,636,1336320000"; 
   d="scan'208";a="5455920"
Message-ID: <500CB1C8.2040406@cn.fujitsu.com>
Date: Mon, 23 Jul 2012 10:07:04 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7.5] kvm: notify host when the guest is
 panicked
References: <500A565A.8080403@cn.fujitsu.com> <500A6BF1.4030002@cn.fujitsu.com> <500BE68D.90005@gmail.com>
In-Reply-To: <500BE68D.90005@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/23 10:02:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/23 10:02:52,
	Serialize complete at 2012/07/23 10:02:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/22/2012 07:39 PM, Sasha Levin Wrote:
> On 07/21/2012 10:44 AM, Wen Congyang wrote:
>> We can know the guest is panicked when the guest runs on xen.
>> But we do not have such feature on kvm.
>>
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is panicked. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is panicked.
>>
>> We have three solutions to implement this feature:
>> 1. use vmcall
>> 2. use I/O port
>> 3. use virtio-serial.
>>
>> We have decided to avoid touching hypervisor. The reason why I choose
>> choose the I/O port is:
>> 1. it is easier to implememt
>> 2. it does not depend any virtual device
>> 3. it can work when starting the kernel
> 
> Was the option of implementing a virtio-watchdog driver considered?

virtio-watchdog? What is this? I don't find it in qemu. Do I miss something?

Another reason why we don't use this:
If the watchdog timeouts, we cannot say the kernel is panicked. For
example, the kernel is hung, or the kernel is deadlock, or ...
the watchdog daemon can not have chance to touch watchdog device.

Thanks
Wen Congyang

> 
> You're basically re-implementing a watchdog, a guest-host interface and a set of protocols for guest-host communications.
> 
> Why can't we re-use everything we have now, push a virtio watchdog driver into drivers/watchdog/, and gain a more complete solution to detecting hangs inside the guest.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

