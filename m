Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2DKLAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:00:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2DKLAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:00:05 -0400
X-IronPort-AV: E=Sophos;i="4.75,405,1330876800"; 
   d="scan'208";a="4730891"
Message-ID: <4F856422.6010904@cn.fujitsu.com>
Date: Wed, 11 Apr 2012 18:59:46 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: avi@redhat.com, mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <20120411102136.GG2428@amd.com>
In-Reply-To: <20120411102136.GG2428@amd.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 18:59:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/11 18:59:28
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年04月11日 18:21, Joerg Roedel 写道:
> Hi,
> 
> On Wed, Apr 11, 2012 at 09:39:43AM +0800, zhangyanfei wrote:
>> The problem is that VMCS internal is hidden by Intel in its
>> specification. So, we reverse engineering it in the way implemented in
>> this patch set.
> 
> Have you made sure this layout is the same on all uarchitectures that
> implment VMX?
> 
> 
> 	Joerg
> 

The layout differs from each other in different VMCS revision identifiers. 
The VMCS revision identifier is contained at the first 32 bits of the VMCS
region. And the VMCS revision identifiers may differ from different architectures.

for example, there are two processors below:
Processor 1: Intel(R) Xeon(R) CPU E7540  @ 2.00GHz with 24 cores
REVISION_ID=e
FIELD(PIN_BASED_VM_EXEC_CONTROL)=05540550
FIELD(CPU_BASED_VM_EXEC_CONTROL)=05440540
FIELD(SECONDARY_VM_EXEC_CONTROL)=054c0548
FIELD(VM_EXIT_CONTROLS) =        057c0578
FIELD(VM_ENTRY_CONTROLS)=        05940590
......

Processor 2: Intel(R) Core(TM)2 Duo CPU E7500  @ 2.93GHz
REVISION_ID=d
FIELD(PIN_BASED_VM_EXEC_CONTROL)=01840180
FIELD(CPU_BASED_VM_EXEC_CONTROL)=01940190
FIELD(SECONDARY_VM_EXEC_CONTROL)=0fe40fe0
FIELD(VM_EXIT_CONTROLS) =        01e401e0
FIELD(VM_ENTRY_CONTROLS)=        03140310

The purpose to get the VMCSINFO of one architecture is for guest debugging that was
running on the same architecture, so there is no problem the layouts differ from different
architectures.

Thanks
Zhang Yanfei

