Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2LSXXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:23:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:39776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab2LSXXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:23:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,320,1355126400"; 
   d="scan'208";a="236664200"
Message-ID: <50D24C83.3080906@linux.intel.com>
Date: Wed, 19 Dec 2012 15:23:47 -0800
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
References: <50CCCFD0.7030704@linux.intel.com> <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com> <50CCEE49.3080801@zytor.com> <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com> <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225505.GA2968@jshin-Toonie>
In-Reply-To: <20121219225505.GA2968@jshin-Toonie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 02:55 PM, Jacob Shin wrote:
> 
> Well, really the problem is with any memory hole above 4GB that is too
> big to be covered by variable range MTRRs as UC. Because the kernel
> use to just simply do init_memory_mapping for 4GB ~ top of memory,
> any memory hole above 4GB are marked as WB in PATs.
> 
> How is this handled in Intel architecture? If there are memory holes
> that are too big to be covered by variable range MTRRs as UC, are
> there other MTRR like CPU registers that the BIOS programs?
> 

Intel CPUs don't have the TOM augmentation to the MTRR mechanism, and so
MTRRs need to explicitly enable caching of memory rather than the other
way around.

	-hpa

