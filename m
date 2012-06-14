Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2FNNWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:22:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab2FNNWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:22:10 -0400
Message-ID: <4FD9E574.90800@redhat.com>
Date: Thu, 14 Jun 2012 16:21:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 5/5] Documentation: Add ABI entry for sysfs file vmcsinfo
 and vmcsinfo_maxsize
References: <4FB35C48.30708@cn.fujitsu.com> <4FB35DEF.2040008@cn.fujitsu.com>
In-Reply-To: <4FB35DEF.2040008@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 10:57 AM, zhangyanfei wrote:
> We create two new sysfs files, vmcsinfo and vmcsinfo_maxsize. And
> here we add an Documentation/ABI entry for them.
> 
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-vmcsinfo b/Documentation/ABI/testing/sysfs-kernel-vmcsinfo
> new file mode 100644
> index 0000000..adbf866
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-vmcsinfo
> @@ -0,0 +1,16 @@
> +What:		/sys/kernel/vmcsinfo
> +Date:		April 2012
> +KernelVersion:	3.4.0
> +Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> +Description
> +		Shows physical address of VMCSINFO. VMCSINFO contains
> +		the VMCS revision identifier and encoded offsets of fields
> +		in VMCS data on Intel processors equipped with the VT
> +		extensions.
> +
> +What:		/sys/kernel/vmcsinfo_maxsize
> +Date:		April 2012
> +KernelVersion:	3.4.0
> +Contact:	Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> +Description
> +		Shows max size of VMCSINFO.
> 

This describes the cpu, so maybe /sys/devices/cpu is a better place for
these files.

Would it make sense to expose the actual fields?

that is, have /sys/devices/cpu/vmcs/0806 contain the offset of
GUEST_DS_SELECTOR.

-- 
error compiling committee.c: too many arguments to function


