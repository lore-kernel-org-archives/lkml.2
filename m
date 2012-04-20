Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2DTKLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:11:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42958 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2DTKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:11:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Apr 2012 19:11:33 +0900 (JST)
Message-Id: <20120420.191133.488341439.d.hatayama@jp.fujitsu.com>
To: avi@redhat.com
Cc: dzickus@redhat.com, luto@mit.edu, gregkh@suse.de, kvm@vger.kernel.org,
        joerg.roedel@amd.com, mtosatti@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        ludwig.nussel@suse.de
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4F900020.5010702@redhat.com>
References: <4F8FF7AC.1060309@redhat.com>
	<20120419.210119.246504497.d.hatayama@jp.fujitsu.com>
	<4F900020.5010702@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump
Date: Thu, 19 Apr 2012 15:08:00 +0300

> On 04/19/2012 03:01 PM, HATAYAMA Daisuke wrote:
>> >> It would be not helpful for the qemu crash case you are concerned
>> >> about. We want to use the guest state data to look into guest
>> >> machine's image in the crasshed qemu.
>> > 
>> > Why?
>> > 
>>
>> It seems natural to check the situation from guest machine's side when
>> qemu crashs. Suppose a service is running on the guest machine, and
>> then the qemu crash. Then, we may need to know the details of the
>> progress of the service if it's important. What has been successfully
>> done, and what has not yet.
> 
> How can a service on the guest be related to a qemu crash?  And how
> would guest registers help?

I don't mean the service is related to qemu's crash. When qemu
crashes, then the guest machine also crashes (although it doesn't
notice anything). What I'm interested in here is guest machine side,
not qemu side. I want to debug guest machine, not qemu.

> 
> You can extract the list of running processes from a qemu crash dump
> without looking at guest registers.  And most vcpus are running
> asynchronously to qemu, so their register contents is irrelevant (if a
> vcpu is running synchronously with qemu - it just exited to qemu and is
> waiting for a response - then you'd see the details in qemu's call stack).
> 

Just as you say, we can refer to guest machine's memory without guest
registers.

The definitely necessary data in vmcs are RSP and RIP, which are not
saved in anywhare of kvm module. The two registers are needed for back
tracing to determine what processsing is being done on the guest
machine at qemu crash.

There are other useful data in vmcs, but even if we don't have them,
we can do what we want to do in exchange of usability.

For example, we want IA32_EFER.LMA to determine whether guest machine
is in 32-bit or 64-bit mode. But there are only two modes, we can
perhaps try these in order in an ad-hoc way.

Other control registers are also useful, but they are not so important
than definitely needed.

Thanks.
HATAYAMA, Daisuke

