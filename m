Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2FNN3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab2FNN3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:29:04 -0400
Message-ID: <4FD9E70A.9090507@redhat.com>
Date: Thu, 14 Jun 2012 16:28:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/5] x86: Add helper variables and functions to hold
 VMCSINFO
References: <4FB35C48.30708@cn.fujitsu.com> <4FB35CD4.3080801@cn.fujitsu.com>
In-Reply-To: <4FB35CD4.3080801@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 10:52 AM, zhangyanfei wrote:
> This patch provides a set of variables to hold the VMCSINFO and also
> some helper functions to help fill the VMCSINFO.

Need to document the format.


> +void vmcsinfo_append_id(u32 id)
> +{
> +	size_t r;
> +
> +	r = sizeof(id);
> +	if (r + vmcsinfo_size > vmcsinfo_max_size)
> +		return;
> +
> +	memcpy(&vmcsinfo_data[vmcsinfo_size], &id, r);
> +	vmcsinfo_size += r;
> +}
> +EXPORT_SYMBOL_GPL(vmcsinfo_append_id);
> +
> +void vmcsinfo_append_field(u32 field, u64 offset)

Why u64?  It's guaranteed to fit within a page.

> +{
> +	size_t r;
> +
> +	r = sizeof(field) + sizeof(offset);
> +	if (r + vmcsinfo_size > vmcsinfo_max_size)
> +		return;
> +
> +	memcpy(&vmcsinfo_data[vmcsinfo_size], &field, sizeof(field));
> +	vmcsinfo_size += sizeof(field);
> +	memcpy(&vmcsinfo_data[vmcsinfo_size], &offset, sizeof(offset));
> +	vmcsinfo_size += sizeof(offset);

Instead of this vmcsinfo_data, how about a struct with fields for the
revision ID and field count, and an array for the fields?  Should be a
lot simpler.

> +}
> +EXPORT_SYMBOL_GPL(vmcsinfo_append_field);
> +
> +unsigned long paddr_vmcsinfo_note(void)
> +{
> +	return __pa((unsigned long)(char *)&vmcsinfo_note);
> +}
> 


-- 
error compiling committee.c: too many arguments to function


