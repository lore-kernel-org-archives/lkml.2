Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2DRJuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:50:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2DRJuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:50:16 -0400
X-IronPort-AV: E=Sophos;i="4.75,441,1330876800"; 
   d="scan'208";a="4782477"
Message-ID: <4F8E8E3D.8040707@cn.fujitsu.com>
Date: Wed, 18 Apr 2012 17:49:49 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        gregkh@suse.de, ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D4B4C.8070705@cn.fujitsu.com> <4F8D4D1C.4010400@redhat.com> <4F8E6DA5.8030503@cn.fujitsu.com> <4F8E7A5B.5030904@redhat.com>
In-Reply-To: <4F8E7A5B.5030904@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/18 17:49:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/18 17:49:20
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年04月18日 16:24, Avi Kivity 写道:
> On 04/18/2012 10:30 AM, zhangyanfei wrote:
>>>
>>> Okay.  Do you expect it to help in debugging the crash?  Did you have
>>> cases where it would help?
>>>
>>
>> Yes, I do expect it to help in debugging the crash.
>> Looking into host machine's crash dump, if we figure out the fact that the crash
>> had happend when some host's resource was requested and used by some guset machine.
>> Then, we surely want to look into the situation from guest machine's view.
>>
>>
> 
> What type of resource?  Can you give an example?
> 
Sorry. No concrete example for now.

We are developing this on a conservative policy and I have put the vmcs processing
in a new module in patch set v2 as you required. The new module is auto-loaded when
the vmx cpufeature is detected and it depends on module kvm-intel. Loading and unloading
this module will have no side effect on the running guests.

And one thing I have to stress is that, we can see guest image as crash dump from
guest machine's view if we have the vmcsinfo, this itself is useful.

Thanks
Zhang Yanfei

