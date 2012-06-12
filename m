Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab2FLHth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:49:37 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:53182 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2FLHtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:49:35 -0400
Message-ID: <4FD6F488.7090303@de.ibm.com>
Date: Tue, 12 Jun 2012 09:49:28 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH] kvm: notify host when guest panicked
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FD6E5EC.3090802@cn.fujitsu.com>
In-Reply-To: <4FD6E5EC.3090802@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12061207-1948-0000-0000-000002100402
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> We have three solutions to implement this feature:
>> 1. use vmcall
>> 2. use I/O port
>> 3. use virtio-serial.
> 
>> We have decided to avoid touching hypervisor. The reason why I choose
>> choose the I/O port is:
>> 1. it is easier to implememt
>> 2. it does not depend any virtual device
>> 3. it can work when startint the kernel

Havent looked deeply into that, butz wouldnt kvm_hypercall0 also fulfill all of these
points? You just have to define the number for each architecture and then it should be 
possible to write a simple panic driver that works on all architectures.

>> --- a/include/linux/kvm_para.h
>> +++ b/include/linux/kvm_para.h
>> @@ -20,6 +20,14 @@
>>  #define KVM_HC_FEATURES			3
>>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
>>  
>> +#define KVM_PV_PORT	(0x505UL)
>> +

ignoring the above, shouldnt a port number go into an architecture specific file?


Christian

