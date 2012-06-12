Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2FLIDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:03:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2FLIDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:03:06 -0400
X-IronPort-AV: E=Sophos;i="4.77,394,1336320000"; 
   d="scan'208";a="5167751"
Message-ID: <4FD6F8AB.5060802@cn.fujitsu.com>
Date: Tue, 12 Jun 2012 16:07:07 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH] kvm: notify host when guest panicked
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FD6E5EC.3090802@cn.fujitsu.com> <4FD6F488.7090303@de.ibm.com>
In-Reply-To: <4FD6F488.7090303@de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 16:03:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 16:03:39,
	Serialize complete at 2012/06/12 16:03:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/12/2012 03:49 PM, Christian Borntraeger Wrote:
>>> We have three solutions to implement this feature:
>>> 1. use vmcall
>>> 2. use I/O port
>>> 3. use virtio-serial.
>>
>>> We have decided to avoid touching hypervisor. The reason why I choose
>>> choose the I/O port is:
>>> 1. it is easier to implememt
>>> 2. it does not depend any virtual device
>>> 3. it can work when startint the kernel
> 
> Havent looked deeply into that, butz wouldnt kvm_hypercall0 also fulfill all of these
> points? You just have to define the number for each architecture and then it should be 
> possible to write a simple panic driver that works on all architectures.

kvm_hypercall0? Avi said that we should avoid touching hypercall.

Thanks
Wen Congyang

> 
>>> --- a/include/linux/kvm_para.h
>>> +++ b/include/linux/kvm_para.h
>>> @@ -20,6 +20,14 @@
>>>  #define KVM_HC_FEATURES			3
>>>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>>>  
>>> +#define KVM_PV_PORT	(0x505UL)
>>> +
> 
> ignoring the above, shouldnt a port number go into an architecture specific file?
> 
> 
> Christian
> 
> 

