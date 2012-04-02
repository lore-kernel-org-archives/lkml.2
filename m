Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2DBKdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:33:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40990 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2DBKdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:33:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,356,1330876800"; 
   d="scan'208";a="4672150"
Message-ID: <4F7979F9.4060509@cn.fujitsu.com>
Date: Mon, 02 Apr 2012 18:05:45 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F66E14F.3040809@cn.fujitsu.com>
In-Reply-To: <4F66E14F.3040809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 18:02:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 18:06:01,
	Serialize complete at 2012/04/02 18:06:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/19/2012 03:33 PM, Wen Congyang Wrote:
> At 03/08/2012 03:57 PM, Wen Congyang Wrote:
>> We can know the guest is paniced when the guest runs on xen.
>> But we do not have such feature on kvm.
>>
>> Another purpose of this feature is: management app(for example:
>> libvirt) can do auto dump when the guest is crashed. If management
>> app does not do auto dump, the guest's user can do dump by hand if
>> he sees the guest is paniced.
>>
>> I touch the hypervisor instead of using virtio-serial, because
>> 1. it is simple
>> 2. the virtio-serial is an optional device, and the guest may
>>    not have such device.
>>
>> Changes from v2 to v3:
>> 1. correct spelling
>>
>> Changes from v1 to v2:
>> 1. split up host and guest-side changes
>> 2. introduce new request flag to avoid changing return values.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> Hi all:
> 
> we neet this feature, but we don't decide how to implement it.
> We have two solution:
> 1. use vmcall
> 2. use virtio-serial.

Hi, all

There are three solutions now:
1. use vmcall
2. use I/O port
3. use virtio-serial.

I think 1 and 2 are more simple than 3.

I am reading virtio-serial's driver recent days. It seems that
if the virtio serial port is not opened at the host side, the
data writen into this port will be discarded, and we will have
no chance to know the guest is panicked.

To Amit:

Can we write message to a virtio serial port like this directly in
the kernel space?
send_buf(panicked_port, message, message's length, true);

if port->outvq_full is true, is it OK to do this?

Thanks
Wen Congyang
> 
> I will not change this patch set before we decide how to do it.
> Can we make a decision recent days?
> 
> Thanks
> Wen Congyang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

