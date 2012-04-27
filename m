Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819Ab2D0RwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:52:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380Ab2D0RwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:52:02 -0400
Message-ID: <4F9ADCAF.5000203@zytor.com>
Date: Fri, 27 Apr 2012 10:51:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] percpu, x86: don't use PMD_SIZE as embedded atom_size
 on 32bit
References: <4F97BA98.6010001@intel.com> <20120425222429.GE8989@google.com> <1335405672.14538.135.camel@ymzhang.sh.intel.com> <20120426224946.GG27486@google.com> <1335488964.14538.159.camel@ymzhang.sh.intel.com> <1335516994.14538.160.camel@ymzhang.sh.intel.com> <20120427165356.GA26595@google.com> <20120427173935.GE26595@google.com>
In-Reply-To: <20120427173935.GE26595@google.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 10:39 AM, Tejun Heo wrote:
> With the embed percpu first chunk allocator, x86 uses either PAGE_SIZE
> or PMD_SIZE for atom_size.  PMD_SIZE is used when CPU supports PSE so
> that percpu areas are aligned to PMD mappings and possibly allow using
> PMD mappings in vmalloc areas in the future.  Using larger atom_size
> doesn't waste actual memory; however, it does require larger vmalloc
> space allocation later on for !first chunks.
> 
> With reasonably sized vmalloc area, PMD_SIZE shouldn't be a problem
> but x86_32 at this point is anything but reasonable in terms of
> address space and using larger atom_size reportedly leads to frequent
> percpu allocation failures on certain setups.
> 
> As there is no reason to not use PMD_SIZE on x86_64 as vmalloc space
> is aplenty and most x86_64 configurations support PSE, fix the issue
> by always using PMD_SIZE on x86_64 and PAGE_SIZE on x86_32.
> 
> v2: drop cpu_has_pse test and make x86_64 always use PMD_SIZE and
>     x86_32 PAGE_SIZE as suggested by hpa.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Yanmin Zhang <yanmin.zhang@intel.com>
> Reported-by: ShuoX Liu <shuox.liu@intel.com>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> LKML-Reference: <4F97BA98.6010001@intel.com>
> Cc: stable@vger.kernel.org

You're carrying this, or should I?

	-hpa

