Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2FKFgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:36:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2FKFgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:36:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,387,1336320000"; 
   d="scan'208";a="5156113"
Message-ID: <4FD58399.4050700@cn.fujitsu.com>
Date: Mon, 11 Jun 2012 13:35:21 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>,
        masanori.yoshida.tv@hitachi.com
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com> <4FC30C40.80500@cn.fujitsu.com> <4FC37D94.3080404@redhat.com> <4FC47579.2040504@cn.fujitsu.com>
In-Reply-To: <4FC47579.2040504@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/11 13:37:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/11 13:37:20
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

于 2012年05月29日 15:06, Yanfei Zhang 写道:
> 于 2012年05月28日 21:28, Avi Kivity 写道:
>> On 05/28/2012 08:25 AM, Yanfei Zhang wrote:
>>>
>>> Dou you have any comments about this patch set?
>>
>> I still have a hard time understanding why it is needed.  If the host
>> crashes, there is no reason to look at guest state; the host should
>> survive no matter what the guest does.
>>
>>
> 
> OK. Let me summarize it.
> 
> 1. Why is this patch needed? (Our requirement)
>    
> We once came to a buggy situation: a host scheduler bug caused guest machine's
> vcpu stopped for a long time and then led to heartbeat stop (host is still running).
>    
> we want to have an efficient way to make the bug analysis when we come to the similar
> situation where guest machine doesn't work well due to something of host machine's, 
> 
> Because we should debug both host machine's and guest machine's sides to look for
> the reasons, so we want to get both host machine's crash dump and guest machine's
> crash dump at the same time when the buggy situation remains. 
> 
> 2. What will we do?
>    
> If this bug was found on customer's environment, we have two ways to avoid
> affecting other guest machines running on the same host. First, we could do bug
> analysis on another environment to reproduce the buggy situation; Second, we
> could migrate other guest machines to other hosts. 
> 
> After the buggy situation is reproduced, we panic the host *manually*.
> Then we could use userland tools to get guest machine's crash dump from host machine's
> with the feature provided by this patch set. Finally we could analyse them separately
> to find which side causes the problem.
> 

Could you please tell me your attitude towards this patch? 

And here is a new case from the LinuxCon Japan:

Developers from Hitach are now developing a new livedump mechanism for the
same reason as ours. They have come to the situation *many times* that guest
machines crashed due to host's failures, in particular, under development.

So they develop this mechanism to get crash dump while retaining the buggy
situation between host and guest machine. The difference between theirs and
ours is whether or not to use the feature on _customer's running machine_.

Thanks
Zhang Yanfei



