Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2HNO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab2HNO4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:56:12 -0400
Subject: Re: [PATCH v8] kvm: notify host when the guest is panicked
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Yan Vugenfirer <yvugenfi@redhat.com>
In-Reply-To: <502A2B7A.3070801@siemens.com>
Date: Tue, 14 Aug 2012 17:55:54 +0300
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <86E2467F-0EA3-4A03-BD89-58E41F7DB808@redhat.com>
References: <5021D235.4050800@cn.fujitsu.com> <20120813182132.GB25268@amt.cnet> <20120814085619.GA32708@redhat.com> <502A2B7A.3070801@siemens.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 14, 2012, at 1:42 PM, Jan Kiszka wrote:

> On 2012-08-14 10:56, Daniel P. Berrange wrote:
>> On Mon, Aug 13, 2012 at 03:21:32PM -0300, Marcelo Tosatti wrote:
>>> On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
>>>> We can know the guest is panicked when the guest runs on xen.
>>>> But we do not have such feature on kvm.
>>>> 
>>>> Another purpose of this feature is: management app(for example:
>>>> libvirt) can do auto dump when the guest is panicked. If management
>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>> he sees the guest is panicked.
>>>> 
>>>> We have three solutions to implement this feature:
>>>> 1. use vmcall
>>>> 2. use I/O port
>>>> 3. use virtio-serial.
>>>> 
>>>> We have decided to avoid touching hypervisor. The reason why I choose
>>>> choose the I/O port is:
>>>> 1. it is easier to implememt
>>>> 2. it does not depend any virtual device
>>>> 3. it can work when starting the kernel
>>> 
>>> How about searching for the "Kernel panic - not syncing" string 
>>> in the guests serial output? Say libvirtd could take an action upon
>>> that?
>> 
>> No, this is not satisfactory. It depends on the guest OS being
>> configured to use the serial port for console output which we
>> cannot mandate, since it may well be required for other purposes.
> 
Please don't forget Windows guests, there is no console and no "Kernel Panic" string ;)

What I used for debugging purposes on Windows guest is to register a bugcheck callback in virtio-net driver and write 1 to VIRTIO_PCI_ISR register.

Yan. 


> Well, we have more than a single serial port, even when leaving
> virtio-serial aside...
> 
> Jan
> 
> -- 
> Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
> Corporate Competence Center Embedded Linux
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

