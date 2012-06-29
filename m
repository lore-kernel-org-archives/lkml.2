Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2F2BzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:55:13 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50574 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2F2BzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:55:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Fri, 29 Jun 2012 10:54:42 +0900 (JST)
Message-Id: <20120629.105442.297827463.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: avi@redhat.com, mtosatti@redhat.com, dzickus@redhat.com, luto@mit.edu,
        kvm@vger.kernel.org, joerg.roedel@amd.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, ebiederm@xmission.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 1/5] x86: Add helper variables and functions to hold
 VMCSINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4FEAC9AE.4090001@cn.fujitsu.com>
References: <4FEAC945.50700@cn.fujitsu.com>
	<4FEAC9AE.4090001@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v3 1/5] x86: Add helper variables and functions to hold VMCSINFO
Date: Wed, 27 Jun 2012 16:51:58 +0800

> This patch provides a set of variables to hold the VMCSINFO and also
> some helper functions to help fill the VMCSINFO.
> 
> Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/vmcsinfo.h |  219 ++++++++++++++++++++++
>  arch/x86/include/asm/vmx.h      |  158 +----------------
>  arch/x86/kernel/Makefile        |    1 +
>  arch/x86/kernel/vmcsinfo.c      |  381 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 603 insertions(+), 156 deletions(-)
>  create mode 100644 arch/x86/include/asm/vmcsinfo.h
>  create mode 100644 arch/x86/kernel/vmcsinfo.c
> 
> diff --git a/arch/x86/include/asm/vmcsinfo.h b/arch/x86/include/asm/vmcsinfo.h
> new file mode 100644
> index 0000000..4b9f56b
> --- /dev/null
> +++ b/arch/x86/include/asm/vmcsinfo.h
> @@ -0,0 +1,219 @@
> +#ifndef _ASM_X86_VMCSINFO_H
> +#define _ASM_X86_VMCSINFO_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/types.h>
> +#include <linux/elf.h>
> +#include <linux/device.h>
> +
> +/* VMCS Encodings */
> +enum vmcs_field {
> +	VIRTUAL_PROCESSOR_ID            = 0x00000000,

<cut>

> +	HOST_RIP                        = 0x00006c16,
> +};
> +
> +/*
> + * vmcs field offsets.
> + */
> +struct vmcsinfo {
> +	u32 vmcs_revision_id;
> +	int filled;
> +	u16 vmcs_field_to_offset_table[HOST_RIP + 1];

HOST_RIP is so large that this array becomes large. Also there are
unused elements in this array because field encoding is not indexed
constantly.

Instead, how about defining the numbr of vmcs fields, 152?, as a
specific constant, indexing each fields using integers and newly
preparing index_to_field_table[]?

Thanks.
HATAYAMA, Daisuke

