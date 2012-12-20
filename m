Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2LTEVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:21:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:24630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab2LTEVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:21:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,320,1355126400"; 
   d="scan'208";a="234301709"
Message-ID: <50D29249.1090109@linux.intel.com>
Date: Wed, 19 Dec 2012 20:21:29 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Yinghai Lu <yinghai@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <50D25AA9.3090306@zytor.com> <20121220002954.GA10405@jshin-Toonie> <50D279F9.4000707@zytor.com> <20121220041621.GA23609@jshin-Toonie>
In-Reply-To: <20121220041621.GA23609@jshin-Toonie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 08:16 PM, Jacob Shin wrote:
> 
> Not exactly sure why the wierd boundaries, I'll have to ask the BIOS
> side folks to be sure. But if I were to guess ..
> 
> Here is the NUMA spew out, physically there is 128 GB connected to
> each memory controller node. The PCI MMIO region starts at 0xc8000000.
> 4 GB - 0xc8000000 = 0x3800000 (896 MB). So we loose 896 MB due to PCI
> MMIO hole, so the first node ends at 128 GB + 896 MB to talk to all of
> 128 GB off of the first memory controller, and hence the weird 896 MB
> offset.
> 

It would obviously be better if the slack were at the end of the total
memory, instead of end of the < 1T range.  If the PCI MMIO hole were a
power of 2 (e.g. 1G) that would also reduce the likelihood of problems
and reduce MTRR pressure.

	-hpa

