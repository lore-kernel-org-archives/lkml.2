Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab2DLUSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:18:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42760 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934651Ab2DLUSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:18:48 -0400
Message-ID: <4F87388C.300@zytor.com>
Date: Thu, 12 Apr 2012 13:18:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
References: <4F87186B.9010303@zytor.com>  <cover.1331622735.git.rubini@gnudd.com> <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com> <20120314065614.GB27480@elte.hu> <20120412201533.GA26533@mail.gnudd.com>
In-Reply-To: <20120412201533.GA26533@mail.gnudd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 01:15 PM, Alessandro Rubini wrote:
> 
> The current approach is using swiotlb and it works pretty well, though
> with a limit of 4MB of swiotlb area.  I've been considering use of the
> DMA zone to this aim: internally I have some half-working thing that
> resuses the ISA DMA zone for our own aims, raising the DMA limit to
> 512MB.
> 
> Do you think the approach may make sense? I use this basic
> thing in Kconfig, to rely on GFP_DMA for the rest:
> 
>   config MAX_DMA_PADDR
>           int
>           default 536870912 if MAX_DMA_PADDR_512M
>           default 16777216
> 
>   config MAX_DMA_PADDR_512M
>           bool
> 
> (actually, we'd benefit from being able to use hex in defaults)
> 
> Is this worth exploring, to possibly submit a patch in this direction?
> 

Not as a compile-time patch.

	-hpa


