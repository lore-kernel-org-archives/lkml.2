Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2CAFUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 00:20:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab2CAFUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 00:20:17 -0500
Message-ID: <4F4F0759.6040106@cn.fujitsu.com>
Date: Thu, 01 Mar 2012 13:21:29 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095557.GE24600@redhat.com> <4F4DF749.7060507@redhat.com> <20120229100550.GF24600@redhat.com> <4F4DF913.5030809@redhat.com> <4F4DFB37.8060208@cn.fujitsu.com> <4F4E0061.1050508@redhat.com>
In-Reply-To: <4F4E0061.1050508@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 13:18:23,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 13:18:26,
	Serialize complete at 2012-03-01 13:18:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 02/29/2012 06:39 PM, Avi Kivity Wrote:
> On 02/29/2012 12:17 PM, Wen Congyang wrote:
>>>>>
>>>> Yes, crash can be so severe that it is not even detected by a kernel
>>>> itself, so not OOPS message even printed. But in most cases if kernel is
>>>> functional enough to print OOPS it is functional enough to call single
>>>> hypercall instruction.
>>>
>>> Why not print the oops to virtio-serial?  Or even just a regular serial
>>> port?  That's what bare metal does.
>>
>> If virtio-serial's driver has bug or the guest doesn't have such device...
> 
> We have the same issue with the hypercall; and virtio-serial is
> available on many deployed versions.

virtio-serial is available, but it is an optional device. If the guest does
not have this device, the guest cannot tell the host that is is paniced. So
I still prefer to touch the hypervisor.

Thanks
Wen Congyang

> 
>>>
>>>>>> Having special kdump
>>>>>> kernel that transfers dump to a host via virtio-serial channel though
>>>>>> sounds interesting. May be that's what you mean.
>>>>>
>>>>> Yes.  The "panic, starting dump" signal should be initiated by the
>>>>> panicking kernel though, in case the dump fails.
>>>>>
>>>> Then panic hypercall sounds like a reasonable solution.
>>>
>>> It is, but I'm trying to see if we can get away with doing nothing.
>>>
>>
>> If we have a reliable way with doing nothing, it is better. But I donot
>> find such way.
> 
> We won't have a 100% reliable way.  But I think a variant of the driver
> that doesn't use interrupts, or just using the ordinary serial driver,
> should be reliable enough.
> 

