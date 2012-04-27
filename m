Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863Ab2D0RRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:17:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38804 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760562Ab2D0RRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:17:37 -0400
Message-ID: <4F9AD49D.6080406@zytor.com>
Date: Fri, 27 Apr 2012 10:17:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] percpu, x86: don't use PMD_SIZE as embedded atom_size
 on 32bit
References: <4F97BA98.6010001@intel.com> <20120425222429.GE8989@google.com> <1335405672.14538.135.camel@ymzhang.sh.intel.com> <20120426224946.GG27486@google.com> <1335488964.14538.159.camel@ymzhang.sh.intel.com> <1335516994.14538.160.camel@ymzhang.sh.intel.com> <20120427165356.GA26595@google.com>
In-Reply-To: <20120427165356.GA26595@google.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 09:53 AM, Tejun Heo wrote:
>  
> +		/*
> +		 * If PSE is available, use PMD_SIZE for atom_size so that
> +		 * embedded percpu areas are aligned to PMD.  This, in the
> +		 * future, can also allow using PMD mappings in vmalloc
> +		 * area.  Use PAGE_SIZE on 32bit as vmalloc space is highly
> +		 * contended and large vmalloc area alloc can easily fail.
> +		 */
> +		atom_size = PAGE_SIZE;
> +#ifdef CONFIG_X86_64
> +		if (cpu_has_pse)
> +			atom_size = PMD_SIZE;
> +#endif

Just make it PAGE_SIZE on i386 and PMD_SIZE on x86-64; keep the behavior
consistent.  !cpu_has_pse on x86-64 is an abnormal situation (I think it
applies to Xen, pretty much.)

Other than that,

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

