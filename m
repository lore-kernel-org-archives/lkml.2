Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab2DSKhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:37:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47994 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2DSKhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:37:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 19 Apr 2012 19:36:40 +0900 (JST)
Message-Id: <20120419.193640.59653378.d.hatayama@jp.fujitsu.com>
To: avi@redhat.com
Cc: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4F8EABF7.805@redhat.com>
References: <4F8E7A5B.5030904@redhat.com>
	<4F8E8E3D.8040707@cn.fujitsu.com>
	<4F8EABF7.805@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump
Date: Wed, 18 Apr 2012 14:56:39 +0300

> On 04/18/2012 12:49 PM, zhangyanfei wrote:
>> >>
>> > 
>> > What type of resource?  Can you give an example?
>> > 
>> Sorry. No concrete example for now.
>>
>> We are developing this on a conservative policy and I have put the vmcs processing
>> in a new module in patch set v2 as you required. The new module is auto-loaded when
>> the vmx cpufeature is detected and it depends on module kvm-intel. Loading and unloading
>> this module will have no side effect on the running guests.
>>
>> And one thing I have to stress is that, we can see guest image as crash dump from
>> guest machine's view if we have the vmcsinfo, this itself is useful.
> 
> Why is it useful?  Without a concrete example, it's hard to justify the
> code bloat.
> 

The reason why we want to retrieve guest machine's memory image as
crash dump is that then we can debug guest machine's status using
symbolic debugger such as gdb and crash utility.

This is very useful. Please consider the situation where engineers are
forced to look into guest machine's memory image through qemu-kvm's
process core dump using gdb without any symbolic information. It's
very inefficient.

Thanks.
HATAYAMA, Daisuke

