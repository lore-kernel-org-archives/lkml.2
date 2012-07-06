Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2GFJSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:18:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2GFJSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:18:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,537,1336320000"; 
   d="scan'208";a="5343098"
Message-ID: <4FF6A0F3.2010201@cn.fujitsu.com>
Date: Fri, 06 Jul 2012 16:25:23 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: zhangyanfei@cn.fujitsu.com, dzickus@redhat.com, luto@mit.edu,
        kvm@vger.kernel.org, joerg.roedel@amd.com, mtosatti@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de, avi@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill
 VMCSINFO
References: <4FF413D2.4030006@cn.fujitsu.com> <4FF4155F.6070508@cn.fujitsu.com> <20120706.170410.119097767.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120706.170410.119097767.d.hatayama@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 16:20:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/06 16:29:22,
	Serialize complete at 2012/07/06 16:29:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/06/2012 04:04 PM, HATAYAMA Daisuke Wrote:
> From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
> Subject: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
> Date: Wed, 4 Jul 2012 18:05:19 +0800
> 
>> Besides, this patch also exports vmcs revision identifier via
>> /sys/devices/system/cpu/vmcs_id and offsets of fields via
>> /sys/devices/system/cpu/vmcs/.
>> Individual offsets are contained in subfiles named by the filed's
>> encoding, e.g.: /sys/devices/cpu/vmcs/0800
> 
> According to the discussion starting from
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00749.html

IIRC, kvm can not work in such environment. The vcpu can run on
different cpu. If the cpu's vmcs is different, I don't know what
will happen. So do we need to support for such environment now?
I think that if kvm can not work in such environment, we should
not provide vmcs information for each physical cpu.

Thanks
Wen Congyang

> 
> system can be composed of CPUs with different steppings or differnet
> microcode revisions. Becase of the nature that it's hided in the
> specification, I suspect layout of vmcs could change across different
> steppings or microcode revisions. Then, the interface needs to be
> changed as per-cpu like
> 
>    /sys/devices/cpu/cpu0/vmcs/0800
>    /sys/devices/cpu/cpu1/vmcs/0800
>    ...
>    /sys/devices/cpu/cpuN/vmcs/0800
> 
> Also, processing of vmcsinfo initialization needs to be done per cpu,
> and can be triggered when cpu is added not when kvm module is loaded.
> 
> Thanks.
> HATAYAMA, Daisuke
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 

