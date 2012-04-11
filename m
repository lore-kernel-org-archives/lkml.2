Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab2DKLmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2DKLmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:42:13 -0400
Message-ID: <4F856E03.1060601@redhat.com>
Date: Wed, 11 Apr 2012 14:41:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 2/4] KVM: VMX: Add functions to fill VMCSINFO
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F84E365.10201@cn.fujitsu.com> <4F85454E.6020201@redhat.com> <4F855E3C.9010003@cn.fujitsu.com>
In-Reply-To: <4F855E3C.9010003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:34 PM, zhangyanfei wrote:
> 于 2012年04月11日 16:48, Avi Kivity 写道:
> > On 04/11/2012 04:50 AM, zhangyanfei wrote:
> >> This patch is to implement the feature that at initialization of
> >> kvm_intel module, fills VMCSINFO with a VMCS revision identifier,
> >> and encoded offsets of VMCS fields. The reason why we put the
> >> VMCSINFO processing at the initialization of kvm_intel module
> >> is that it's dangerous to rob VMX resources while kvm module is
> >> loaded.
> > 
> > Maybe it should be done by a separate module.
> > 
>
> If we put vmcsinfo processing at the initialization of kvm_intel module,
> as soon as the kvm_intel module is loaded, VMCSINFO is filled. And it is
> because vmcsinfo processing is at the initialization of kvm_intel module,
> no kvm guests are running, so it will not rob any VMX resources.
>
> If it is done by a separate module, I am afraid this module may not be
> loaded when the kernel needs VMCSINFO.
>

You can make the module autoload when the vmx cpufeature is detected. 
But then there is an ordering problem wrt kvm-intel.

-- 
error compiling committee.c: too many arguments to function

