Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2E2HJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:09:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57549 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab2E2HJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:09:24 -0400
X-IronPort-AV: E=Sophos;i="4.75,675,1330876800"; 
   d="scan'208";a="5066651"
Message-ID: <4FC47579.2040504@cn.fujitsu.com>
Date: Tue, 29 May 2012 15:06:33 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com> <4FC30C40.80500@cn.fujitsu.com> <4FC37D94.3080404@redhat.com>
In-Reply-To: <4FC37D94.3080404@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/29 15:07:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/29 15:07:36
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年05月28日 21:28, Avi Kivity 写道:
> On 05/28/2012 08:25 AM, Yanfei Zhang wrote:
>>
>> Dou you have any comments about this patch set?
> 
> I still have a hard time understanding why it is needed.  If the host
> crashes, there is no reason to look at guest state; the host should
> survive no matter what the guest does.
> 
> 

OK. Let me summarize it.

1. Why is this patch needed? (Our requirement)
   
We once came to a buggy situation: a host scheduler bug caused guest machine's
vcpu stopped for a long time and then led to heartbeat stop (host is still running).
   
we want to have an efficient way to make the bug analysis when we come to the similar
situation where guest machine doesn't work well due to something of host machine's, 

Because we should debug both host machine's and guest machine's sides to look for
the reasons, so we want to get both host machine's crash dump and guest machine's
crash dump at the same time when the buggy situation remains. 

2. What will we do?
   
If this bug was found on customer's environment, we have two ways to avoid
affecting other guest machines running on the same host. First, we could do bug
analysis on another environment to reproduce the buggy situation; Second, we
could migrate other guest machines to other hosts. 

After the buggy situation is reproduced, we panic the host *manually*.
Then we could use userland tools to get guest machine's crash dump from host machine's
with the feature provided by this patch set. Finally we could analyse them separately
to find which side causes the problem.

Thanks
Zhang Yanfei

   
