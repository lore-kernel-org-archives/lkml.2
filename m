Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2DQCAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:00:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2DQCAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:00:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,432,1330876800"; 
   d="scan'208";a="4767631"
Message-ID: <4F8CCCEA.2090706@cn.fujitsu.com>
Date: Tue, 17 Apr 2012 09:52:42 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: avi@redhat.com, mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 3/4] ksysfs: export VMCSINFO via sysfs
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F84E50E.2090008@cn.fujitsu.com> <20120412230058.GA23292@kroah.com>
In-Reply-To: <20120412230058.GA23292@kroah.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 09:52:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 09:52:21
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年04月13日 07:00, Greg KH 写道:
> On Wed, Apr 11, 2012 at 09:57:34AM +0800, zhangyanfei wrote:
>> This patch creates sysfs file to export where VMCSINFO is allocated,
>> as below:
>>         $ cat /sys/kernel/vmcsinfo
>>         1cb88a0 2000
>> number on the left-hand side is the physical address of VMCSINFO,
>> while the one on the right-hand side is the max size of VMCSINFO.
> 
> Ick, why do you have 2 values in one sysfs file, that's not nice, or
> good.
> 
> What's wrong with 2 different files?
> 

The reason why I put the 2 values in one sysfs file is that there is a similar
file 'vmcoreinfo' in sysfs.
        # cat /sys/kernel/vmcoreinfo 
        1d75380 1000
Nothing wrong with two different files, I just wanted to export the vmcsinfo
with the interface that is the same as vmcoreinfo. So later in kexec-tools,
vmcsinfo note information will be handled in a very similar way as vmcoreinfo
note information.

> Also, any new sysfs file you add needs to also have a Documentation/ABI
> entry added as well.

Sorry for missing this. I will add it in next version of patch.

> 
> But we can't accept this as-is, sorry, please split it up into 2 files.
>
 
Thanks
Zhang Yanfei

