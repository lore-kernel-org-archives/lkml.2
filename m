Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040Ab2JaJBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:01:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43674 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934894Ab2JaJBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:01:05 -0400
From: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: RE: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
 loading kvm_intel module
Thread-Topic: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
 loading kvm_intel module
Thread-Index: AQHNtxjWd33TRFBYyUiov2M7lbohbZfTHDjw
Date: Wed, 31 Oct 2012 09:01:01 +0000
Message-ID: <33710E6CAA200E4583255F4FB666C4E20AACCA2F@G01JPEXMBYT03>
References: <50909B55.2070901@cn.fujitsu.com>
 <50909C35.9080702@cn.fujitsu.com>
In-Reply-To: <50909C35.9080702@cn.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.124.101.123]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kexec-bounces@lists.infradead.org
> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of zhangyanfei
> Sent: Wednesday, October 31, 2012 12:34 PM
> To: x86@kernel.org; kexec@lists.infradead.org; Avi Kivity; Marcelo
> Tosatti
> Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when
> loading kvm_intel module
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

[...]

> @@ -7230,6 +7231,10 @@ static int __init vmx_init(void)
>  	if (r)
>  		goto out3;
> 
> +#ifdef CONFIG_KEXEC
> +	crash_clear_loaded_vmcss = vmclear_local_loaded_vmcss;
> +#endif
> +

Assignment here cannot cover the case where NMI is initiated after VMX is on in kvm_init and before vmclear_local_loaded_vmcss is assigned, though rare but can happen.

What does happen if calling vmclear_local_loaded_vmcss before kvm_init? I think it no problem since the list is initially empty.

>  	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
>  	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
>  	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
> @@ -7265,6 +7270,10 @@ static void __exit vmx_exit(void)
>  	free_page((unsigned long)vmx_io_bitmap_b);
>  	free_page((unsigned long)vmx_io_bitmap_a);
> 
> +#ifdef CONFIG_KEXEC
> +	crash_clear_loaded_vmcss = NULL;
> +#endif
> +
>  	kvm_exit();
>  }

Also, this is converse to the above.

Thanks.
HATAYAMA, Daisuke

