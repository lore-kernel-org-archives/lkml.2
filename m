Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866Ab2EVEAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:00:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2EVEAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:00:14 -0400
X-IronPort-AV: E=Sophos;i="4.75,636,1330876800"; 
   d="scan'208";a="5008519"
Message-ID: <4FBB0DB7.3040909@cn.fujitsu.com>
Date: Tue, 22 May 2012 11:53:27 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <CAG7+5M2nc3qPAS-GvX=YoVKqwdwSGdesoBQ6nsksHp2LFfzYcQ@mail.gmail.com>
In-Reply-To: <CAG7+5M2nc3qPAS-GvX=YoVKqwdwSGdesoBQ6nsksHp2LFfzYcQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 11:53:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/22 11:53:34
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年05月22日 02:58, Eric Northup 写道:
> On Wed, May 16, 2012 at 12:50 AM, zhangyanfei
> <zhangyanfei@cn.fujitsu.com> wrote:
>>
>> This patch set exports offsets of VMCS fields as note information for
>> kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
>> runtime state of guest machine image, such as registers, in host
>> machine's crash dump as VMCS format. The problem is that VMCS internal
>> is hidden by Intel in its specification. So, we slove this problem
>> by reverse engineering implemented in this patch set. The VMCSINFO
>> is exported via sysfs to kexec-tools just like VMCOREINFO.
> 
> Perhaps I'm wrong, but this solution seems much, much more dynamic
> than it needs to be.
> 
> The VMCS offsets aren't going to change between different boots on the
> same CPU, unless perhaps the microcode has been updated.
> 
> So you can have the VMCS offset dumping be a manually-loaded module.
> Build a database mapping from (CPUID, microcode revision) -> (VMCSINFO).
> There's no need for anything beyond the (CPUID, microcode revision) to
> be put in the kdump, since your offline processing of a kdump can then
> look up the rest.
> 
> It means you don't have to interact with the vmx module at all, and
> no extra modules or code have to be loaded on the millions of Linux
> machines that won't need the functionality.
> 

We have considered this way, but there are two issues:
1) vmx resource is unique for a single cpu, and it's risky to grab it forcibly
on the environment where kvm module is used, in particular on customer's environment.
To do this safely, kvm support is needed.

2) It highly costs to prepare each cpu to each customer environment to collect
vmcsinfo. After all, there are various environments on our customer's.

Our patch provides a module, so those who doesn't want this feature can just
stop it being auto-loaded when system starts up.

Thanks
Zhang Yanfei

