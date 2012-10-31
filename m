Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2JaBmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:42:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2JaBmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:42:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,684,1344182400"; 
   d="scan'208";a="6102877"
Message-ID: <50908354.5070608@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 09:48:04 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com> <20121031011256.GC12325@amt.cnet>
In-Reply-To: <20121031011256.GC12325@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 09:41:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 09:41:37,
	Serialize complete at 2012/10/31 09:41:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/31/2012 09:12 AM, Marcelo Tosatti Wrote:
> On Thu, Oct 25, 2012 at 11:42:32AM +0800, Hu Tao wrote:
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
> It has been asked earlier why a simple virtio device is not usable
> for this (with no response IIRC).

1. We can't use virtio device when the kernel is booting.
2. The virtio's driver can be built as a module, and if it is not loaded
   and the kernel is panicked, there is no way to notify the host.
3. I/O port is more reliable than virtio device.
   If virtio's driver has some bug, and it cause kernel panicked, we can't
   use it. The I/O port is more reliable because it only depends on notifier
   chain(If we use virtio device, it also depends on notifier chain).

Thanks
Wen Congyang

> 
> Also, there is no high level documentation: purpose of the interface,
> how a management application should use it, etc.
> 
> 

