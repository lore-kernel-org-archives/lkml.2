Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2GJB2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:28:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47887 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2GJB2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:28:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Tue, 10 Jul 2012 10:28:32 +0900 (JST)
Message-Id: <20120710.102832.104908620.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: avi@redhat.com, mtosatti@redhat.com, dzickus@redhat.com, luto@mit.edu,
        kvm@vger.kernel.org, joerg.roedel@amd.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, ebiederm@xmission.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to
 fill VMCSINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4FF4155F.6070508@cn.fujitsu.com>
References: <4FF413D2.4030006@cn.fujitsu.com>
	<4FF4155F.6070508@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
Date: Wed, 4 Jul 2012 18:05:19 +0800

> 
> Besides, this patch also exports vmcs revision identifier via
> /sys/devices/system/cpu/vmcs_id and offsets of fields via
> /sys/devices/system/cpu/vmcs/.

I think /sys/devices/system/cpu/vmcs/id is more natural, which also
belongs to vmcs.

<cut>
> +/*
> + * vmcs field offsets.
> + */
> +static struct vmcsinfo {
> +	u32 vmcs_revision_id;
> +	u16 vmcs_field_to_offset_table[HOST_RIP + 1];
> +} vmcsinfo;

This is what I said previously. HOST_RIP is 0x00006c16 => 27670. This
means sizeof (struct vmcsinfo) => 55346 bytes == 54 kbytes. But
actually exported fields are only 153, so 4 + 2 * 153 => 310 bytes are
enough.

How about getting the number of attributes from vmcs_attrs array? I
guess this is exactly the number of vmcs fields exported; here 153.

Thanks.
HATAYAMA, Daisuke
