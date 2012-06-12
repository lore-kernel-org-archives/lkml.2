Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2FLJuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:50:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2FLJuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:50:11 -0400
Date: Tue, 12 Jun 2012 12:49:57 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] kvm: notify host when guest panicked
Message-ID: <20120612094957.GR580@redhat.com>
References: <4FB9E4CE.8060709@cn.fujitsu.com>
 <4FD6E5EC.3090802@cn.fujitsu.com>
 <4FD6F488.7090303@de.ibm.com>
 <4FD6FD3B.2090800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD6FD3B.2090800@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 04:26:35PM +0800, Wen Congyang wrote:
> At 06/12/2012 03:49 PM, Christian Borntraeger Wrote:
> >>> We have three solutions to implement this feature:
> >>> 1. use vmcall
> >>> 2. use I/O port
> >>> 3. use virtio-serial.
> >>
> >>> We have decided to avoid touching hypervisor. The reason why I choose
> >>> choose the I/O port is:
> >>> 1. it is easier to implememt
> >>> 2. it does not depend any virtual device
> >>> 3. it can work when startint the kernel
> > 
> > Havent looked deeply into that, butz wouldnt kvm_hypercall0 also fulfill all of these
> > points? You just have to define the number for each architecture and then it should be 
> > possible to write a simple panic driver that works on all architectures.
> > 
> >>> --- a/include/linux/kvm_para.h
> >>> +++ b/include/linux/kvm_para.h
> >>> @@ -20,6 +20,14 @@
> >>>  #define KVM_HC_FEATURES			3
> >>>  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> >>>  
> >>> +#define KVM_PV_PORT	(0x505UL)
> >>> +
> > 
> > ignoring the above, shouldnt a port number go into an architecture specific file?
> 
> I am not sure whether it should be put into an architecture specific file.
> 
Because PIO is x86 thing.

--
			Gleb.
