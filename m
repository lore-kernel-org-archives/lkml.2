Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2DSKnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 06:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2DSKnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 06:43:01 -0400
Message-ID: <4F8FEC22.400@redhat.com>
Date: Thu, 19 Apr 2012 13:42:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F8E7A5B.5030904@redhat.com> <4F8E8E3D.8040707@cn.fujitsu.com> <4F8EABF7.805@redhat.com> <20120419.193640.59653378.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120419.193640.59653378.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 01:36 PM, HATAYAMA Daisuke wrote:
> From: Avi Kivity <avi@redhat.com>
> Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump
> Date: Wed, 18 Apr 2012 14:56:39 +0300
>
> > On 04/18/2012 12:49 PM, zhangyanfei wrote:
> >> >>
> >> > 
> >> > What type of resource?  Can you give an example?
> >> > 
> >> Sorry. No concrete example for now.
> >>
> >> We are developing this on a conservative policy and I have put the vmcs processing
> >> in a new module in patch set v2 as you required. The new module is auto-loaded when
> >> the vmx cpufeature is detected and it depends on module kvm-intel. Loading and unloading
> >> this module will have no side effect on the running guests.
> >>
> >> And one thing I have to stress is that, we can see guest image as crash dump from
> >> guest machine's view if we have the vmcsinfo, this itself is useful.
> > 
> > Why is it useful?  Without a concrete example, it's hard to justify the
> > code bloat.
> > 
>
> The reason why we want to retrieve guest machine's memory image as
> crash dump is that then we can debug guest machine's status using
> symbolic debugger such as gdb and crash utility.
>
> This is very useful. Please consider the situation where engineers are
> forced to look into guest machine's memory image through qemu-kvm's
> process core dump using gdb without any symbolic information. It's
> very inefficient.

I still don't follow.  If qemu crashed, the values in guest registers
are irrelevant.  In what way can the help debug the qemu crash?

-- 
error compiling committee.c: too many arguments to function

